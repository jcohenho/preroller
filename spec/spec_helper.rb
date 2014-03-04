ENV["RAILS_ENV"] ||= 'test'
SPEC_ROOT = File.dirname(__FILE__)

AUDIO_ROOT = File.join SPEC_ROOT, "fixtures", "audio"
AUDIO_MASTER = File.open(File.join(AUDIO_ROOT, '1-burst1sec.mp3'))
require 'bundler/setup'

require 'combustion'
Combustion.initialize! :active_record, :action_controller, :action_view

require 'rspec/rails'
require 'factory_girl'
load 'factories.rb'

Dir["#{SPEC_ROOT}/support/**/*.rb"].each { |f|require f }

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = true
  config.order = "random"
  config.include FactoryGirl::Syntax::Methods
  config.include ParamHelper
  config.include RemoteStubs

  config.after(:suite) do
    Dir["#{AUDIO_ROOT}/*"].each do |file|
      File.delete(file) unless FileUtils.compare_file(file, AUDIO_MASTER)
    end
  end
end
