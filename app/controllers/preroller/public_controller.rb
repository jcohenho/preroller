module Preroller
  class PublicController < ApplicationController
    skip_before_filter :require_login

    # Handle a preroll request, delivering either a preroll file encoded in
    # the format asked for by the stream or an empty response if there is no
    # preroll
    def preroll
      @campaign = Campaign.find_by_key(key: params[:key], context: params[:context], consistent_preroll: params[:consistentPreroll])
      if @campaign
        # key format should be (codec)-(samplerate)-(channels)-(bitrate)-(mono/stereo)
        # For instance: mp3-44100-16-64-m, aac-44100-16-48-m, etc

        if file = @campaign.file_for_stream_key(params[:stream_key])
          # Got it... send a file
          send_file file, :disposition => 'inline' and return
        else
          render :text => "", :status => :ok and return
        end
      else
        render :text => "", :status => :ok and return
      end
    end
  end
end
