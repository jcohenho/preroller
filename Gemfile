source 'https://rubygems.org'

gem 'rails', '3.2.2'

gem 'rack-raw-upload'
gem "streamio-ffmpeg", :git => "git://github.com/SCPR/streamio-ffmpeg.git"
#gem "streamio-ffmpeg", :path => "/Users/eric/projects/forks/streamio-ffmpeg"
gem "resque"

gem "redis-store"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
  gem "less-rails-bootstrap"
end

gem 'jquery-rails'
group :development, :test do
  gem 'debugger'
end
group :test do
  gem 'activerecord'
  gem 'actionpack'
  gem "sqlite3"
  gem "combustion"
  gem 'rspec-rails', '~> 2.13.0'
  gem 'sqlite3_ar_regexp', '~> 2.0'
  gem 'shoulda-matchers'
end

gemspec
