module Preroller
  class AudioEncoding < ActiveRecord::Base
    @queue = :preroller

    belongs_to :campaign

    #default_scope where("stream_key != 'master'")
    scope :master, where(:stream_key => "master")

    before_destroy :delete_cache_and_img
    after_create :encode_resque

    attr_accessible :stream_key, :size, :duration, :extension

    def path
      if self.fingerprint
        File.join(Rails.application.config.preroller.audio_dir,"#{self.campaign_id}-#{self.fingerprint}.#{self.extension}")
      else
        return nil
      end
    end

    #----------

    # key format for MP3 should be (codec)-(samplerate)-(bitrate)-(mono/stereo)
    # For instance: mp3-44100-64-m, aac-44100-48-m, etc


    # key format for AAC should be (codec)-(samplerate)-(profile index)-(number of channels)
    # For instance: aac-44100-2-1, aac-44100-3-2, etc

    #----------

    def encode_resque
      Resque.enqueue(AudioEncoding, self.id)
    end

    #----------

    def encode
      raise "encode not defined for #{self.class}"
    end

    #----------

    def self.perform(id)
      ae = AudioEncoding.find(id)
      ae.encode
    end

    #----------

    private
    def delete_cache_and_img
      # delete our file
      File.delete(self.path) if self.path && File.exists?(self.path)
      # delete cache?
    end

  end
end
