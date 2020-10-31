# This picks up after rspec-update (roughly, it may be uneven)
# (And it was in that in the git for a while, sorry)

# Okay now I've been writing in bundle updates, but those caused code changes, so I should put those here too?
# First, cumcumber now sees "Log in" instead of "Sign in"; that was fixable
# Now, it doesn't seem a "monthly_reports" view in the database...which is true, there isn't one in test.
# Not clear why this is true, or why it's a problem only now

# Ah ha! A clue. The view *does* exist if I drop and recreate the table
dropdb foodlobby_test
RAILS_ENV=test bundle exec rake db:setup
# and then
bundle exec rspec
# AND
bundle exec cumcumber
# passes. but if I run 
bundle exec rake
# monthly_reports gets dropped sometime between rspec and cucumber
bundle exec rake cumcumber
# also drops the view; so I guess it's something about how rake runs cucumber?
# just going with it for now

git commit -m Rails 4.2

# now factoryGirl
grep -e FactoryGirl -r . -l | grep -e ".*\.rb$" | xargs sed -i "" "s|FactoryGirl|FactoryBot|" # in os x
# edit Gemfile
# edit spec/factories.rb as I am yelled at to do

# create config/secrets.yml, I left notes there how I kludged it together

git commit -m FactoryBot

# Can't seem to upgrade past rails 4.2 with ruby 2.2.X
# So, 2.3.8
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/lib/ssl1.0/" rbenv install
#gem install bundle
# oops
#gem uninstall bundler
gem install bundler -v "<2" -N
bundle install

git commit -m Ruby 2.3.8

# add 'rails', '~>5.0.0'

# Hmm, I added protected_attributes to the Gemfile and that is my problem.
# Why did I add protected_attributes to the Gemfile?
# ah ha, https://github.com/rails/protected_attributes , for `attr_accessible`
# Remove protected_attributes
bundle update rails
# pg doesn't load! Hmm.

# gem 'pg', '~>0.18.0'
bundle update pg

# edit user model to remove attr_accessible
# (It's just commented out, what was it doing? It's not doing it anymore.)

# before_action became before_filter, or the other way, who cares

# None of the specs seem to be able to hit authenticate_user!, so complain when it's skipped
# I just put `raise: false` (via below) but that doesn't seem like the best
# https://stackoverflow.com/questions/41266207/rails-before-process-action-callback-authenticate-user-has-not-been-defined

# Also in specs, I had to add params: a bunch of times (a few times passing an empty hash)

# I had to add .to_h to the transaction create method, not clear why

# .csv is complaining about accessing mime types, but not in a way that is helpful, so I'm leaving it
# (And household.xml isn't working, but maybe it never was)

# I can only seem to access the signout url via gets (method: :delete doesn't work) so I added a get route
# https://stackoverflow.com/a/30095074
# (No I do not know what I did, why it's devise_scope or user is singular)
# (Note this didn't cause any tests to fail, so, there's I guess no test for that)

git commit -m Rails 5.0

# add 'rails', '~>5.1.0'
bundle update rails

# t.void_was stopped working, t.void_before_last_save now

# stylesheets are supposed to go in app/assets, but doing that triggers other errors
# so I added `skip_pipeline: true`, which was the suggestion of the warning

# .csv upgraded to error! It was worth a shot
# oh it was just
bundle update comma
# thought that would have happened with rails, oh well it's fine

git commit -m Rails 5.1

# add 'rails', '~>5.2.0'
bundle update rails

# rails5.2 seems to drop the household_id into the transaction hash?
# look at the git/comments to see, it's a kludge but working right now

# and success became successful, whatever fine

git commit -m Rails 5.2

# ruby "2.4.10"
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/lib/ssl1.0/" rbenv install

gem install bundle
bundle install # there we go
# seems okay here

# let's do it and be legends?
sudo apt-get install openssl libssl-dev
rbenv uninstall 2.4.10
rbenv install
gem install bundle
bundle install

git commit -m Ruby 2.4.10

# ruby "2.5.8"
rbenv install
gem install bundle
bundle install

# pg, step through 1.0.0, 1.1.0, and no restriction, all seem to run

git commit -m Ruby 2.5.8

# tried bundle update, no good, running through every gem the problem appears to be sprockets, so
#gem 'sprockets', '~>3.0'
bundle update

git commit -m bundle update

# ruby "2.6.6"
rbenv install
gem install bundle
bundle install

# BigDecimal.new -> BigDecimal, sure np

git commit -m Ruby 2.6.6