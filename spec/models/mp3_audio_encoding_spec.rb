require 'spec_helper'

describe Preroller::MP3AudioEncoding do
  it { should validate_presence_of(:bitrate) }
end

describe '#encode' do

  context 'given a master audio file' do
    before do
      @campaign = create :campaign
      @master_encoding = build :audio_encoding, campaign: @campaign, is_master: true, fingerprint: 'burst1sec'
      Preroller::AudioEncoding.any_instance.stub(:encode_resque)
      @master_encoding.save
    end

    context 'given encoding values for sample rate, profile and channels' do
      before do
        @mp3_encoding = build :mp3_audio_encoding, campaign: @campaign, sample_rate: 44100, profile: 2, channels: 1
        Preroller::AudioEncoding.any_instance.stub(:encode_resque)
        @mp3_encoding.save
      end

      subject { @mp3_encoding.encode }
      it 'encodes an aac audio file and returns true' do
        subject.should eq true

        File.exists?(File.join(AUDIO_ROOT, "#{@mp3_encoding.campaign.id}-#{@mp3_encoding.fingerprint}.#{@mp3_encoding.extension}")).should eq true
        @mp3_encoding.size.should_not be_nil
        @mp3_encoding.extension.should eq 'mp3'
      end
    end
  end
end


