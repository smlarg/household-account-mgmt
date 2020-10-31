ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require "bootsnap/setup" # I guess rails 6 app:update didn't just plop this here (which seems better)