---
title: Blacklight Instance for The Best 50 Years in Gaming site (Version 2)
author: Steven Ng
date: 2020-04-14
---

# Blacklight Instance for The Best 50 Years in Gaming site (Version 2)

## System Requirements

Requires Ruby 2.7.2

This Blacklight instance requires SolrCloud. A local version of SolrCloud may be run
by using the TULibraries Ansible SolrCloud Playbook:
https://github.com/tulibraries/ansible-playbook-solrcloud

SolrCloud will require Docker...

## Getting started

Clone the github repository locally and change into the directory

    git clone https://github.com/tulibraries/gencon50.git
    cd gencon50

### Install

Install the gem dependencies (generally we do this in an rvm gemset)

    bundle install

Run the database migration

    bundle exec rails db:migrate

Create the application file

    cp .env.example .env

and edit the `.env` content's `SOLR_URL` enviornment variable.

## Configure for Solr

Configure dotenv to use SolrWrapper

    cp .env.example .env

Ensure .env contains

    SOLR_URL="http://localhost:8090/solr/gencon50-v3.0.1"

Solr may be run with Solr_Wrapper or SolrCloud (preferred).

### Start up with `solr_wrapper`

In a separate terminal window:

    bundle exec solr_wrapper

### Start up SolrCloud

    cd ../ansible-playbook-solrcloud
    make up-lite
    cd ../gencon50

Create a local user. Feel free to use your own email and password

    bundle exec rails runner " User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password').save!"

Start the Gencon50 application

    bundle exec rails server`

Ingest some data

To seed the database with a csv file form the command line ,use the following command. Replace `path/to/datafile.csv`
with the path to the file to upload.

    bin/csv2solr harvest path/to/datafile.csv --mapfile=config/solr_map.yml

In a web browser, visit http://localhost:3000 and search the Gencon programs for the first fifty years.


## Running the Tests

Setup for developing new request and feature tests

Tests require an instance of Solr to which to connect, and run once to record into the VCR gem test fixtures.
To update the initial index database to create these fixtures, go to the `ansible-playbook-solrcloud`, restart the SolrCloud
instance with `make up-lite`.

Testing requires a fresh solr index. restart Solr Cloud instances before running these tests.

If you need to access Solr index to generate new tests, harvest the csv files in the spec/fixtures directory

    LOADSOLR=y bundle exec rspec spec

Ensure that requests to the Solr server are in VCR blocks. For example:

    VCR.use_cassette("responseDefaultIndex", record: :once) do
      get "?search_field=all_fields&q="
    end

Note the `:record` mode is set to once. After you perform this spec, change the record mode to `:none`.

Subsequent runs of the specs should execute without need to connect to the Solr server. At this point, you may go to the
`andible-playbook-solrcloud` directory and stop SolrCloud instance with `make down`

Execute your specs with:

    bundle exec rspec spec

## CI/CD

Each branch and each PR merge will trigger a build on CircleCI that will run all tests.

### QA Deploy
Merges to `main` trigger a deploy to qa.

### Prod Deploy
Creating a release triggers a deploy to production.

