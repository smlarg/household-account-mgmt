Foodlobby
=========
The EcoVillage food-coop uses this to track our households, including their
balance, members, and all their transactions.


Update Status
---

As of now (Nov. 2020) someone who didn't know Rails before just completed upgrading the stack.
Everything seems to run well, but it's fair to say it's back in beta.


Running in Vagrant
=======

Again at the moment this is still a bit manual, because I haven't learned how "provisioning" is done in vagrant (but it's not so bad!)

First, if you haven't yet, install
[VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://vagrantup.com).

I believe you still need the vagrant-vbguest plugin, though I don't see how to uninstall it to check that it fails without. So probably just install it:

    localhost> vagrant plugin install vagrant-vbguest
    
I'm assuming you've cloned the repo by now; if not please do, and check out master

    localhost> git clone https://github.com/smlarg/household-account-mgmt.git && cd household-account-mgmt && git checkout master
    
Then start vagrant

    localhost> vagrant up

This will take a couple minutes, as the virtual machine image downloads and configures itself.

Once it's done, you'll want to manually connect to the machine, and move to the mirrored version of the source directory
 
    localhost> vagrant ssh
    vagrant> cd /vagrant

So far we just have a generic Ubuntu instance, so we'll want to install all our Ruby and Rails packages.
First, we'll want [rbenv](https://github.com/rbenv/rbenv), which manages multiple Ruby versions, all stored in the user's home directory.
Since this is a virtual machine it's not strictly necessary - you can vandalize the system all you want! - but it's still convenient.
They also made a nice little script which automates the install:

    vagrant > curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash

I don't know why but that script doesn't [setup](https://linuxize.com/post/how-to-install-ruby-on-ubuntu-18-04/) the necessary shell parameters, it just informs you that it didn't.
So, do so (here assuming bash).

    vagrant > echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    vagrant > echo 'eval "$(rbenv init -)"' >> ~/.bashrc && source ~/.bashrc

Now you'll want rbenv to install the correct version of Ruby for you (specified in .ruby_version).

    vagrant> rbenv install

This will also take a moment, as it's downloading and compiling from source.

Once that's done Ruby will be working, but you'll also want Rails and all the other "gems" listed in Gemfile and Gemfile.lock ; [bundler](https://bundler.io/) , which should be installed already, will take care of this for you.
    
    vagrant> bundle install

At this point you'll have an error, because I forgot to tell you to install postgres

    vagrant> sudo apt-get install -y postgresql libpq-dev

Try that again (or you can do it in the right order, if you prefer)

    vagrant> bundle install

You'll now want to create a database user with write access (name and password 'vagrant', which is setup in config/database.yml)

    vagrant> sudo -u postgres createuser -d vagrant

Now rails can setup a(n empty) database in postgres (using the migration files in db/migrate, and/or the various schema files, also in db/).

    vagrant> bundle exec rails db:setup

At this point the app should be functional. You can double check by running the test suite

    vagrant> rake

(I'm not sure why rake is directly in your path at this point, but rails is still handled by bundler.
`bundle exec rake` will also work, if you want more consistency.)

You *will* still get a few deprecation warnings. We're working on that! You can safely ignore them.

If you're going to download the current database (see below), you can skip this step.
If not, you'll need a user to login and do anything.
One way to create one is using the rails console

    vagrant> bundle exec rails console
    irb(main):001:0> User.create!({:email => "any@string.whichParsesAsAnEmail", :password => "password", :password_confirmation => "password"})
    irb(main):002:0> exit

Hopefully you should be all set up to go now, so launch your server!

    vagrant> bundle exec rails server -b 0.0.0.0

(Binding to 0.0.0.0 is a kludge because vagrant seems to be confused about whether 127.0.0.1 is the *virtual* localhost or the *physical* localhost.
If you know a better way, let me know!)

Now just navigate to the page via any web browser and you should have a fully functional local foodlobby website.

    localhost> firefox http://localhost:4001

Database and setting up Heroku
--------

As mentioned earlier, you should now have a working but totally empty database.
You can still add all the entries you need by hand if you want (either through the web or the rails console).

Alternatively, you can download a snapshot of the current database.
To do so you will first have to [sign up](https://signup.heroku.com/) for an account on heroku.com,
and then be given access to foodlobby.herokuapp.com by one of the collaborators.

Once that's done, you'll need to setup the heroku CLI tools on the virtual machine and sign in from there as well

    vagrant> sudo snap install --classic heroku
    vagrant> heroku login -i

I believe adding the heroku git remote is an optional step, but it may be handy later.

    vagrant> git remote add heroku https://git.heroku.com/foodlobby.git

Now just drop the local database (with a single, non-password protected and unconfirmed command!) and replace it with the remote copy.

    vagrant> dropdb foodlobby_development
    vagrant> heroku pg:pull HEROKU_POSTGRESQL_JADE_URL foodlobby_development --app foodlobby

Launch the server again and you should find all the entries that were current at the time you made the copy.

    vagrant> bundle exec rails server -b 0.0.0.0
