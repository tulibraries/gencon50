---
title: Blacklight Instance for The Best 50 Years in Gaming site (Version 2)
author: Steven Ng
date: 2020-04-14
---

# Blacklight Instance for The Best 50 Years in Gaming site (Version 2)

## Prerequisite

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

Start up SolrCloud

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

Tests require an instance of Solr to which to connect.

Work with a fresh Solr database. In `ansible-playbook-solrcloud`, restart the SolrCloud
instance with `make up-lite`.

Testing requires a fresh solr index. restart Solr Cloud instances before running these tests.

The first run, load the test fixture

    LOADSOLR=y bundle exec rspec spec

No need to reload the test fixtures on subsequent runs:

    bundle exec rspec spec

## Deployment instructions
