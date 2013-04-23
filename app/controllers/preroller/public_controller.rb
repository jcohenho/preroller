module Preroller
  class PublicController < ApplicationController
    skip_before_filter :require_login
    
    # Handle a preroll request, delivering either a preroll file encoded in 
    # the format asked for by the stream or an empty response if there is no 
    # preroll
    def preroll
      # is this output key valid?
      @output = Output.where(:key => params[:key]).first
    
      if !@output
        render :text => "Invalid output key.", :status => :not_found and return
      end
    
      # Valid key.  Now, are there any running campaigns?
      campaigns = @output.campaigns.active
    
      # FIXME: Add path matching
      # FIXME: Add UI matching
      
      # This gives us the opportunity to ensure that the same 
      # preroll will always be returned, so that we can know
      # (more or less) what the response content-length will be.
      # If static=true, then it will return the first (most recently
      # created) active campaign. Otherwise, it chooses a random one.
      if params[:consistentPreroll]
        @campaign = campaigns.first
      else
        @campaign = campaigns.any? ? campaigns[ rand( campaigns.length ) ] : nil
      end
      
      if @campaign
        # Now we need to figure out how to handle the stream key they've passed us
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
