require 'spec_helper'

describe Preroller::AudioEncoding do

  describe 'path to the audio file' do
    context 'if a fingerprint exists' do
      it 'compiles a URL to the audio' do
        audio_encoding = build :audio_encoding, fingerprint: '123'
        Preroller::AudioEncoding.any_instance.stub(:encode_resque)
        audio_encoding.save

        audio_encoding.path.should eq File.join(AUDIO_ROOT, "#{audio_encoding.campaign.id}-#{audio_encoding.fingerprint}.#{audio_encoding.extension}")
      end
    end

    context 'if a fingerprint doesnt exist' do
      it 'returns nil' do
        audio_encoding = build :audio_encoding, fingerprint: nil
        Preroller::AudioEncoding.any_instance.stub(:encode_resque)
        audio_encoding.save

        audio_encoding.path.should eq nil
      end
    end
  end

end
