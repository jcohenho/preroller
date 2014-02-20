ENV["RAILS_ENV"] ||= 'test'
SPEC_ROOT = File.dirname(__FILE__)

require 'bundler/setup'

require 'preroller'
require 'combustion'
Combustion.initialize! :active_record, :action_controller, :action_view

require 'rspec/rails'


RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = true
  config.order = "random"
end
