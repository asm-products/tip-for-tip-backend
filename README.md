Tip for Tip Backend/API
=======================

The Tip for Tip database, API, and management. TRIPLE BAM!

---

<img src='http://cl.ly/image/442N191I2L0g/gif.gif' width='100%' />

---

Summary
-------

- Rails 4
- [Mysql](#database)
- [Rspec](#testing)
- [Hosted on Heroku](#deployment)
- [Apiary for documentation](#documentation)

Quick commands
--------------

Run the app locally on (default) port 5000

```
foreman start
```

Run the REPL

```
foreman run rails c
```

Run the specs

```
rspec
```

Configure
---------

The `.env` file and `.foreman` files should be used for any local configuration
of the app.

Customize the port:

```
PORT=4567
```

Database
--------

Manage the database the same way you would with any Rails app.

```
# Create the database
rake db:create

# Runs pending migration
rake db:migrate

# Rolls back a migration
rake db:rollback

# Seed local data
rake db:seed
```

Deployment
----------

Deploys are currently all to Heroku apps. Be sure you're a contributor on the app
you wish to deploy to, add it as a git remote, and git push to it.

```
git remote add heroku git@heroku.com:tipfortip-api.git
git push heroku master
```

Testing
-------

A typical Rspec setup is used for writing specs and testing against them, and FactoryGirl
is used for fixtures. To run the tests:

```
rspec
```

Documentation
-------------

The API interface is specified using [Apiary](http://docs.tipfortip.apiary.io/). Changes
to the `apiary.apib` file in this repo are picked up on pushes to Github automatically and
reflected on Apiary.

