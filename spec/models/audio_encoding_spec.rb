require 'spec_helper'

describe Preroller::AudioEncoding do

  describe 'path to the audio file' do
    context 'if a fingerprint exists' do
      it 'compiles a URL to the audio' do
        audio_encoding = create :audio_encoding, fingerprint: '123'

        audio_encoding.path.should eq File.join(AUDIO_ROOT, "#{audio_encoding.campaign.id}-#{audio_encoding.fingerprint}.#{audio_encoding.extension}")
      end
    end

    context 'if a fingerprint doesnt exist' do
      it 'returns nil' do
        audio_encoding = create :audio_encoding, fingerprint: nil
        audio_encoding.path.should eq nil
      end
    end
  end

  describe '::valid_stream_key?' do
    it 'returns true if key is valid' do
      valid_key = 'aac-44100-2-1'
      Preroller::AudioEncoding.valid_stream_key?(valid_key).should eq true
    end

    it 'returns false if key is invalid' do
      invalid_key = 'mp3-blah-123-412'
      Preroller::AudioEncoding.valid_stream_key?(invalid_key).should eq false
    end
  end

  describe '#_encode' do

    context 'given a master audio file' do
      before do
        @campaign = create :campaign
        master_encoding = create :audio_encoding, campaign: @campaign, stream_key: 'master', fingerprint: 'burst1sec'
      end

      context 'given an mp3 stream key' do
        before do
          @mp3_encoding = create :audio_encoding, campaign: @campaign, stream_key: 'mp3-44100-48-m'
        end

        subject { @mp3_encoding._encode }

        it 'encodes an mp3 audio file with the right format and returns true' do
          subject.should eq true
          File.exists?(File.join(AUDIO_ROOT, "#{@mp3_encoding.campaign.id}-#{@mp3_encoding.fingerprint}.#{@mp3_encoding.extension}")).should eq true
        end
      end

      context 'given an aac stream key' do
        before do
          @aac_encoding = create :audio_encoding, campaign: @campaign, stream_key: 'aac-44100-2-1'
        end

        subject { @aac_encoding._encode }

        it 'encodes an aac audio file with the right format and returns true' do
          subject.should eq true
          File.exists?(File.join(AUDIO_ROOT, "#{@aac_encoding.campaign.id}-#{@aac_encoding.fingerprint}.#{@aac_encoding.extension}")).should eq true
       end
      end

    end
  end
end
