module Preroller
  class Campaign < ActiveRecord::Base
    class InvalidAudioError < Error
    end

    belongs_to :output
    has_many :encodings, :class_name => "AudioEncoding", :dependent => :destroy

    scope :active, lambda { where("start_at < ? and end_at > ? and active = ?",Time.now,Time.now, true).order("created_at desc") }

    attr_accessible :title, :metatitle, :output_id, :start_at, :end_at, :path_filter, :ua_filter

    #----------

    def self.find_by_key(options={})

      # The consistent_preroll option  gives us the opportunity to ensure that the same
      # preroll will always be returned, so that we can know
      # (more or less) what the response content-length will be.
      # If static=true, then it will return the first (most recently
      # created) active campaign. Otherwise, it chooses a random one.

      # If a specific context was given, try to find a campaign
      # which matches that context. If no campaign matches, then
      # we'll just select a random active campaign.
      if options[:consistent_preroll].present?
        joins(:output).where(preroller_outputs: { key: options[:key] }).active.first
      elsif options[:context].present?
        joins(:output).where("preroller_outputs.key = ? AND path_filter REGEXP ?", options[:key], options[:context] ).active.sample
      else
        joins(:output).where("preroller_outputs.key = ? AND path_filter IS ? OR path_filter = ?", options[:key], nil, '').active.sample
      end
    end

    def fingerprint
      m = self.encodings.master.first
      return m ? m.fingerprint : false
    end

    #----------

    # Takes a stream key and returns a file path
    # MP3 Stream key format: (codec)-(samplerate)-(bitrate)-(m/s)
    # AAC Stream key format: (codec)-(samplerate)-(profile)-(1/2)
    # For instance: mp3-44100-64-m, aac-44100-48-m, etc

    def file_for_stream_key(key)
      # -- do we have a cache for this campaign and key? -- #

      if fingerprint && (c = Rails.cache.read("#{id}-#{fingerprint}:#{key}"))
        return c
      end
      codec, encoding_options = key.split '-', 2
      encoding = case codec
        when 'mp3' then MP3AudioEncoding
        when 'aac' then AACAudioEncoding
        else raise InvalidAudioError
      end.find_by_encoding(campaign_id: id, key: key, encoding_options: encoding_options).first_or_create
      encoding.path
      #remember to call fire_resque_encoding when you create the audioencoding
    end

    #----------

    def save_master_file(f)
      # -- make sure it's a valid audio file -- #

      snd = FFMPEG::Movie.new(f.path)

      if !snd.valid?
        raise InvalidAudioError
      end

      # -- find or create master AudioEncoding -- #

      master = self.encodings.master.first_or_create

      # grab the extension of the input file
      ext_match = /\.(\w+)/.match(f.original_filename)

      ext = nil
      if ext_match
        ext = ext_match[1]
      end

      master.attributes = {
        :size       => snd.size,
        :duration   => snd.duration,
        :extension  => ext || snd.audio_codec
      }

      # -- get a fingerprint -- #

      master.fingerprint = Digest::MD5.hexdigest(f.read)
      f.rewind if f.respond_to?(:rewind)

      puts "fingerprint is #{print}"

      # -- save -- #

      File.open( master.path, "w", :encoding => "ascii-8bit") do |newf|
        newf << f.read
      end

      master.save

      # -- delete any other existing AudioEncodings -- #

      self.encodings.each do |ae|
        next if ae == master
        ae.destroy
      end

      # -- update our own active status -- #

      self.active = true
      self.save

      return true
    end

    #----------
  end
end
