# Blacklight Instance for The Best 50 Years in Gaming site (Version 2)

## Prerequisite

This Blacklight instance requires SolrCloud. A local version of SolrCloud may be run
by using the TULibraries Ansible SolrCloud Playbook:
https://github.com/tulibraries/ansible-playbook-solrcloud

## Getting started

Clone the github repository locally and change into the directory

```
git clone https://github.com/tulibraries/gencon50.git
cd gencon50
```

### Setup

Install the gem dependencies (generally we do this in an rvm gemset)

```
bundle install
```

Run the database migration

```
bundle exec rails db:migrate
```

Create the application file

```
cp .env.example .env
```
and edit the `.env` content's `SOLR_URL` enviornment variable.

Create a local user. Feel free to use your own email and password

```
bundle exec rails runner " User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password').save!"
```

Start the rails server

```
bundle exec rails s`
---


# Running the Tests

Tests require an instance of Solr to which to connect.

Work with a fresh Solr database. In `ansible-playbook-solrcloud`, restart the SolrCloud
instance with `make up-lite`.

- Run the tests

The first run, load the test fixture
```
LOADSOLR=y bundle exec rspec spec
```

No need to reload the test fixtures on subsequent runs:
```
bundle exec rspec spec
```

* Deployment instructions
