#-------First create a test app-------

heroku create --remote heroku-18 --stack heroku-18 foodlobby-heroku-18

heroku addons --remote heroku
heroku addons:create --remote heroku-18 heroku-postgresql
heroku addons:create --remote heroku-18 newrelic # No, needs a credit card
heroku addons:create --remote heroku-18 sendgrid # No, needs a credit card

git push heroku-18 rails-6 # Ah no, has to be 'master' Um, hmm.
# oh well
git fast-forward-merge master # that is not the command
git push heroku-18 master

# didn't detect rails configuration?
heroku config:set --remote heroku-18 HEROKU_DEBUG_RAILS_RUNNER=1
# unhelpful

heroku pg:push foodlobby_development DATABASE --remote heroku-18
# and restart dyno, and that was my problem!

#-------

#------DON'T DO YET - EXCEEDS ROW LIMIT------

# To upgrade the real app, I *think* this is the approach
# c.f. https://devcenter.heroku.com/articles/upgrading-to-the-latest-stack

# REALLY FIRST go onto the web interface and set to Maintanence Mode

# first
heroku stack:set heroku-18 -a foodlobby
# this does nothing, because there's no new version triggered

# then
git push heroku master # we'll see if I have push access
# also should I push to git (and get README.md up to snuff) (and fix bundle exec rake) first?
# or is it do a pull request? Mrgrrhmm.

# then
heroku --app foodlobby run rails db:migrate

# then
heroku stack:set heroku-18 -a foodlobby