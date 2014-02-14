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
      context = params[:context]

      # This gives us the opportunity to ensure that the same
      # preroll will always be returned, so that we can know
      # (more or less) what the response content-length will be.
      # If static=true, then it will return the first (most recently
      # created) active campaign. Otherwise, it chooses a random one.
      if params[:consistentPreroll]
        @campaign = campaigns.first
      else
        # If a specific context was given, try to find a campaign
        # which matches that context. If no campaign matches, then
        # we'll just select a random active campaign.
        if context.present?
          filtered = campaigns.select do |c|
            c.path_filter.present? && context.match(c.path_filter)
          end

          # We now have an array of campaigns for this context.
          # Take a random one. If the array was empty, we'll still have
          # nil, so then fallback to a random campaign that *doesn't*
          # specify a context.
          # If there aren't any other ones, then we'll still have nil and
          # no prerolls will be sent.
          @campaign = filtered.sample
          @campaign ||= campaigns.select { |c| c.path_filter.empty? }.sample
        end
      end

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
