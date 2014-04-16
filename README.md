[![Build Status](https://travis-ci.org/denyago/psms-example-bad-news.svg?branch=master)](https://travis-ci.org/denyago/psms-example-bad-news)
[![Code Climate](https://codeclimate.com/github/denyago/psms-example-bad-news.png)](https://codeclimate.com/github/denyago/psms-example-bad-news)

# Fortumo Mobile Payments API Example

The SMS service 'Bad News' will deliver you worst news if you
want to feel sad. Not for free.

Uses [Mobile Payments API of Fortumo](http://developers.fortumo.com/mobile-payments-api/)

## Deploy

### Using Heroku

Set `PSMS_INFO_URL` to URL 'where you can download your service information and promotional texts' from Fortumo Dashboard (My Services > _Your Service_ > Setup)

    heroku config:set SECRET_KEY_BASE=`ruby -e 'require "securerandom"; print SecureRandom.hex(128)'`
    heroku config:set PSMS_INFO_URL=https://api.fortumo.com/api/services/2/xxx.yyy.xml
    heroku config:set FORTUMO_SECRET=XXXYYYZZZ

    ssh remote add heroku XXX
    git push origin heroku
    heroku run rake db:create
    heroku run rake db:migrate
    heroku run rake db:seed
    heroku restart
