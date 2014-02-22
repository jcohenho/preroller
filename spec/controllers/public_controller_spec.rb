require 'spec_helper'

describe Preroller::PublicController do

  describe 'GET preroll' do

    context 'with a valid output key and stream key' do
      before(:each) do
        @output = create :output, key: 'mp3'
        @valid_stream_key = 'mp3-44100-48-m'
      end

      context 'with an existing active campaign' do
        before(:each) do
          @campaign = create :active_campaign, output: @output
        end

        context 'with a context param' do
          before do
            @context = 'cool'
            @campaign_with_context = create :active_campaign, output: @output, path_filter: @context
            @other_campaign = create :active_campaign, output: @output, path_filter: 'bro'
            @another_campaign = create :active_campaign, output: @output, path_filter: 'doge'
            Preroller::Campaign.any_instance.stub(:file_for_stream_key).with(@valid_stream_key).and_return(@audio_file)
          end

          it 'selects a random campaign related to the given context' do
            get :preroll, public_request_params(key: @output.key, stream_key: @valid_stream_key, context: @context)
            assigns(:campaign).should eq @campaign_with_context
          end
        end

        context 'with a consistentPreroll param' do
          before do
            @campaign2 = create :active_campaign, output: @output
            @campaign3 = create :active_campaign, output: @output
            Preroller::Campaign.any_instance.stub(:file_for_stream_key).with(@valid_stream_key).and_return(@audio_file)
            get :preroll, public_request_params(key: @output.key, stream_key: @valid_stream_key, consistentPreroll: true)
          end

          it 'selects the first campaign' do
            assigns(:campaign).should eq @campaign3
          end
        end


        context 'with an existing audio file' do

          it 'returns an audio file output' do
            @audio_file = load_audio_fixture('point1sec.mp3')
            Preroller::Campaign.any_instance.stub(:file_for_stream_key).with(@valid_stream_key).and_return(@audio_file)
            get :preroll, public_request_params(key: @output.key, stream_key: @valid_stream_key)
            assigns(:output).should eq @output
            response.body.should eq IO.binread(@audio_file)
          end
        end

        context 'without an audio file' do
          it 'returns a 200 with an empty body' do
            Preroller::Campaign.any_instance.stub(:file_for_stream_key).with(@valid_stream_key).and_return(false)
            get :preroll, public_request_params(key: @output.key, stream_key: @valid_stream_key)
            response.status.should eq 200
            response.body.should eq ""
          end
        end
      end

      context 'without an active campaign' do
        it 'returns a 200 with an empty body' do
          @campaign = create :campaign, output: @output
          get :preroll, public_request_params(key: @output.key, stream_key: @valid_stream_key)
          response.status.should eq 200
          response.body.should eq ""
        end
      end
    end

    context 'with an invalid output key' do
      it 'returns a 404 not found' do
        @output = create :output, key: 'mp3'
        get :preroll, public_request_params(key: 'badkey')
        response.status.should eq 404
      end
    end
  end
end
