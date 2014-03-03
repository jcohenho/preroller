require 'spec_helper'

describe Preroller::AACAudioEncoding do
  it { should validate_presence_of(:profile) }
end

describe '#encode' do

  context 'given a master audio file' do
    before do
      @campaign = create :campaign
      @master_encoding = build :audio_encoding, campaign: @campaign, stream_key: 'master', fingerprint: 'burst1sec'
      Preroller::AudioEncoding.any_instance.stub(:encode_resque)
      @master_encoding.save
    end

    context 'given encoding values for sample rate, profile and channels' do
      before do
        @aac_encoding = build :aac_audio_encoding, campaign: @campaign, sample_rate: 44100, profile: 2, channels: 1
        Preroller::AudioEncoding.any_instance.stub(:encode_resque)
        @aac_encoding.save
      end

      subject { @aac_encoding.encode }
      it 'encodes an aac audio file and returns true' do
        subject.should eq true

        File.exists?(File.join(AUDIO_ROOT, "#{@aac_encoding.campaign.id}-#{@aac_encoding.fingerprint}.#{@aac_encoding.extension}")).should eq true
        @aac_encoding.size.should_not be_nil
        @aac_encoding.extension.should eq 'aac'
      end
    end
  end
end

