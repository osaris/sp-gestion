SP-Gestion
==========

Code status
===========

Tests : [![Build Status](https://travis-ci.org/osaris/sp-gestion.png)](https://travis-ci.org/osaris/sp-gestion)

Coverage : [![Coverage Status](https://coveralls.io/repos/osaris/sp-gestion/badge.png)](https://coveralls.io/r/osaris/sp-gestion)

Quality : [![Code Climate](https://codeclimate.com/github/osaris/sp-gestion.png)](https://codeclimate.com/github/osaris/sp-gestion)

Dependencies : [![Dependency Status](https://gemnasium.com/osaris/sp-gestion.png)](https://gemnasium.com/osaris/sp-gestion)

Prerequisites
=============

* Ruby 1.9.3
* Mysql
* memcached
* ImageMagick
* HTTP server with ruby support (Pow, Apache/Nginx+Passenger, Webrick, Thin...)

Setup
=====

* checkout source :

```
git clone https://github.com/osaris/sp-gestion.git
```

* go into master :

```
cd sp-gestion
```

* install bundler :

```
gem install bundler
```

* install all required gem :

```
bundle install
```

* copy `config/sp-gestion.sample.yml` to `config/sp-gestion.yml` and change its content to fit your setup

* edit `config/database.yml` (if necessary)

* create database, load schema and import seed data :

```
rake db:setup
```

* setup local dns or host file for *.dev resolution (native with Pow) and configure sp-gestion.dev
  Add 127.0.0.1       cpi-demo.sp-gestion.dev and 127.0.0.1  www.sp-gestion.dev in your hosts unless you have Pow
* browse `www.sp-gestion.dev` for home
* browse `demo.sp-gestion.dev` for a sample account (login : demo@sp-gestion.dev | pass : demospg)

Emails
======

Development environment is configured to use [Mailcatcher](http://mailcatcher.me/).
Simply run `gem install mailcatcher` then `mailcatcher` to get started.

Tests
=====

* prepare database :

```
rake db:test:prepare
```

* run `rspec`

Deployment
==========

* [Capistrano](http://www.capistranorb.com/) is included in the `Gemfile` and a
sample configuration file is delivered in `config/deploy.sample.rb`.

Production
==========

* if you want to use newrelic you must have an account (http://newrelic.com/)
and generate the `config/newrelic.yml` file by running `newrelic install` in the
root folder of the application.

Licensing
=========

SP-Gestion is released under the [MIT License](http://www.opensource.org/licenses/MIT).