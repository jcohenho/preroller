module Preroller
  class AACAudioEncoding < AudioEncoding

    validates_presence_of :profile

    def self.find_by_encoding(options={})
      sample_rate, profile, channels = options[:encoding_options].split '-', 3
      where(campaign_id: options[:campaign_id], sample_rate: sample_rate, profile: profile, channels: channels)
    end

    def encode
      master = campaign.encodings.master.first

      # we'll encode into a temp file and then move it into place
      f = Tempfile.new(['preroller', '.aac'])
      begin
        mfile = FFMPEG::Movie.new(master.path)
        mfile.transcode(f.path, {
          custom:             %Q! -metadata title="#{campaign.metatitle.gsub('"','\"')}"!,
          audio_codec:        'libfaac',
          audio_sample_rate: sample_rate,
          audio_channels: channels
          }
        )
        # make sure the file we created is valid...
        newfile = FFMPEG::Movie.new(f.path)
        if newfile.valid?
          # add our attributes
          self.attributes = {
            size:         newfile.size,
            duration:     newfile.duration,
            extension:   'aac' || newfile.audio_codec
          }
          # grab a fingerprint
          f.rewind if f.respond_to?(:rewind)
          self.fingerprint = Digest::MD5.hexdigest(f.read)
          f.rewind if f.respond_to?(:rewind)

          # now write it into place in our final location
          File.open(path, 'w', encoding: "ascii-8bit") do |ff|
            ff << f.read()
          end

          self.save
        end
      ensure
        f.close
        f.unlink
      end

      return true

    end

  end
end

