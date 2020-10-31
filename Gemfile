source 'http://rubygems.org'

ruby "2.7.2"

gem 'rails', '~>5.2.0'
#gem 'protected_attributes'
gem 'rake'
gem 'will_paginate'
gem 'newrelic_rpm'

# for postgres
gem 'pg'

# for authentication
gem 'devise'
gem 'devise-encryptable'

# for authorization
gem 'cancan'

# helper to annotate model files with schema
gem 'annotate'

#csv export support
gem 'comma'

# send email when an exception occurs
gem 'exception_notification'

# After upgrading to 5.0 I was told to put this in, for assigns
gem 'rails-controller-testing'

# Hold sprockets down for the time being
gem 'sprockets', '~>3.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'rspec-rails', '~>3.0'
  gem 'rspec-activemodel-mocks'
  gem 'factory_bot_rails'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'pry'
end
