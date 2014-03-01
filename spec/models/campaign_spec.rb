require 'spec_helper'

describe Preroller::Campaign do
  describe '#find_by_key' do
    subject(:preroller_campaign) { Preroller::Campaign }

    context 'given the consistent preroll option is present' do
      before do
        @campaign = create :active_campaign
        @options = { consistent_preroll: true, key: @campaign.output.key }
      end

      it 'returns the first active campaign for the given key' do
        preroller_campaign.find_by_key(@options).should eq @campaign
      end
    end

    context 'given the context option is present' do
      before do
        context = 'blah'
        @campaign = create :active_campaign, path_filter: context
        @options = { context: context, key: @campaign.output.key }
      end

      it 'returns a random campaign with the given context' do
        preroller_campaign.find_by_key(@options).should eq @campaign
      end
    end

    context 'given no context option or consistent_preroll is present' do
      before do
        @campaign = create :active_campaign
        @options = { key: @campaign.output.key }
      end

      it 'returns a random campaign' do
        preroller_campaign.find_by_key(@options).should eq @campaign
      end
    end
  end
end
