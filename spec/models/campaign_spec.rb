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
        @context = 'blah'
        @campaign = create :active_campaign, path_filter: @context
      end

      context 'given a matching context' do
        before do
          @options = { context: 'blah-website', key: @campaign.output.key }
        end
        it 'returns a random campaign containing a matching context' do
          preroller_campaign.find_by_key(@options).should eq @campaign
        end
      end

      context 'given a non-matching context' do
        before do
          @campaign_with_no_context = create :active_campaign
          @options = { context: 'no-match', key: @campaign_with_no_context.output.key }
        end
        it 'returns a random campaign for the key without a context' do
          preroller_campaign.find_by_key(@options).should eq @campaign_with_no_context
        end

        # This only fails on MySQL if there are no parentheses around the
        # conditionals in find_by_key.
        it "doesn't return anything if the key has no active campaigns" do
          campaign = create :active_campaign, path_filter: ""
          preroller_campaign.find_by_key(context: 'no-match', key: 'nope').should be_nil
        end
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
