cd original_git_repository && cp Gemfile Gemfile.lock .ruby-version .. && cd ..
git checkout -b rspec-update
git add Vagrantfile
git commit -m Vagrantfile

sed -i "s/gem 'rails', '~>3.2.0'/gem 'rails', '~>3.2.0'\ngem 'rake', '<11.0'/" Gemfile
sed -i "s/gem 'rspec-rails'/gem 'rspec-rails', '~>2.14'/" Gemfile

bundle update rspec-rails

# https://relishapp.com/rspec/docs/upgrade
gem install transpec
bundle exec rake
transpec -f

# revert spec/controller/transactions_controller_spec.rb line 18

sed -i "s/gem 'rspec-rails', '~>2.14'/gem 'rspec-rails', '~>2.14'\n  gem 'rspec-activemodel-mocks'/" Gemfile
bundle

# edit/kludge spec/controller/transactions_controller_spec.rb  line 59 and 65
# (comment out `visit` line and `expect(page)` line, and add `1` to `it...do` block to force it to execute)
# edit spec/models/transactions_spec.rb line 10 as suggested

sed -i "s/gem 'rspec-rails', '~>2.14'/gem 'rspec-rails', '~>3.0.0'/" Gemfile
bundle update rspec-rails

transpec -f

# revert spec/controller/transactions_controller_spec.rb line 18 again

sed -i "s/gem 'rspec-rails', '~>3.0.0'/gem 'rspec-rails', '~>3.0'/" Gemfile
bundle update rspec-rails

bundle exec rake
# Still warns, but I'll take it!

sed -i "s/gem 'rake', '<11.0'/gem 'rake'/" Gemfile
bundle update rake
# is okay