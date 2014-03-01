require 'spec_helper'

describe Preroller::PublicController do
  describe 'GET preroll' do
    context 'given a valid stream key that matches to an active campaign with an existing audio file' do
      before do
        @valid_stream_key = 'mp3-44100-48-m'
        @output = create :output, key: 'mp3'
        @campaign = create :active_campaign, output: @output
      end

      it 'returns the contents of the audio file of the campaign' do
        @audio_file = AUDIO_MASTER
        Preroller::Campaign.any_instance.stub(:file_for_stream_key).with(@valid_stream_key).and_return(@audio_file)
        get :preroll, public_request_params(key: @output.key, stream_key: @valid_stream_key)
        response.body.should eq IO.binread(@audio_file)
      end
    end
  end
end

