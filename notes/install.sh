git clone https://github.com/michaelkirk/household-account-mgmt.git
mv household-account-mgmt heroku-foodlobby && cd heroku-foodlobby

# note this is BSD sed syntax (why would they make it different?!?)
sed -i '' 's/eduardodeoh\/precise64-rails-dev/hashicorp\/bionic64/' Vagrantfile
sed -i '' 's/host: 4001/host: 4001, auto_correct: true/' Vagrantfile

vagrant up
vagrant ssh

sudo apt-get -y install openssl1.0 libssl1.0-dev libssl1.0.0 libpq-dev postgresql
sudo -u postgres createuser -d vagrant

curl -sL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash -
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

cd /vagrant
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/lib/ssl1.0/" rbenv install

gem install bundler -v "<2" -N

bundle install
bundle exec rake db:setup
bundle exec rake

# bundle exec rails server -b 0.0.0.0

sudo snap install --classic heroku
heroku login -i

git remote add heroku https://git.heroku.com/foodlobby.git

dropdb foodlobby_development
heroku pg:pull HEROKU_POSTGRESQL_JADE_URL foodlobby_development --app foodlobby