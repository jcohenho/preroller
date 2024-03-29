module Preroller
  class Admin::CampaignsController < ApplicationController

    layout "preroller/admin"

    before_filter :load_campaign, :except => [:index,:new,:create]

    def index
      @campaigns = Campaign.all
    end

    #----------

    def show

    end

    #----------

    # Set campaign status to the inverse of the status we receive
    def toggle
      if params[:status] == 'true'
        @campaign.active = false
      elsif params[:status] == 'false'
        @campaign.active = true
      end

      @campaign.save
    end

    #----------

    def upload
      if params[:file]
        @campaign.save_master_file(params[:file])
        render :text => "Success!", :status => :ok
      else
        render :text => "Must provide an audio file.", :status => :error
      end
    rescue Campaign::InvalidAudioError
      # -- failed -- #
      render :text => "Invalid audio file?", :status => :error
    end

    #----------

    def new
      @campaign = Campaign.new
    end

    #----------

    def create
      @campaign = Campaign.new

      if @campaign.update_attributes params[:campaign]
        flash[:notice] = "Campaign created!"
        redirect_to admin_campaign_path @campaign
      else
        flash[:error] = "Failed to create campaign: #{@campaign.errors}"
        render :action => :new
      end

    end

    #----------

    def edit

    end

    #----------

    def update
      if @campaign.update_attributes params[:campaign]
        flash[:notice] = "Campaign updated!"
        redirect_to admin_campaign_path @campaign
      else
        flash[:error] = "Failed to update campaign: #{@campaign.errors}"
        render :action => :edit
      end

    end

    #----------

    def destroy

    end

    #----------

    private
    def load_campaign
      @campaign = Campaign.where(:id => params[:id]).first

      if !@campaign
        raise
      end
    rescue
      redirect_to admin_campaigns_path and return
    end

  end
end
