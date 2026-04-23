---
title: Blacklight Instance for The Best 50 Years in Gaming site (Version 2)
author: Steven Ng
date: 2020-04-14
---

# Blacklight Instance for The Best 50 Years in Gaming site (Version 2)

## System Requirements

Requires Ruby 3.4.2

This Blacklight instance requires SolrCloud. The Solr collection is populated by an
external DAG, so this application expects to connect to an already-populated
collection rather than loading source data itself.

For local SolrCloud development, use the TULibraries Ansible SolrCloud Playbook:
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

and edit the `.env` content's `SOLR_URL` environment variable so it points to the
Solr collection populated by the DAG.

## Configure for Solr

Configure dotenv with the Solr collection URL

    cp .env.example .env

Ensure `.env` contains the desired Gencon50 Solr collection, for example:

    SOLR_URL="http://localhost:8090/solr/gencon50-1.0"

The application does not populate the Solr collection locally. If you need data in
Solr, run the DAG that manages collection population and point `SOLR_URL` at that
collection.

### Start up SolrCloud

    cd ../ansible-playbook-solrcloud
    make up-lite
    cd ../gencon50

Create a local user. Feel free to use your own email and password

    bundle exec rails runner " User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password').save!"

Start the Gencon50 application

    bundle exec rails server

In a web browser, visit http://localhost:3000 and search the Gencon programs for the first fifty years.


## Running the Tests

Setup for developing new request and feature tests

Tests run standalone and do not require a live Solr instance for routine execution.

Execute your specs with:

    bundle exec rspec spec

To re-record VCR cassettes, pass the VCR arg to rspec

Re-recording cassettes requires an instance of Solr to connect to. To update the
initial index data used to create those fixtures, go to `ansible-playbook-solrcloud`,
restart the SolrCloud instance with `make up-lite`, and ensure the DAG has populated
the target collection.

    VCR=all bundle exec rspec spec
    or
    VCR=all bundle exec rspec spec/features/visit_site_spec.rb

Ensure that requests to the Solr server are in VCR blocks set initially to record. For example:

    VCR.use_cassette("responseDefaultIndex", record: :once) do
      get "?search_field=all_fields&q="
    end

Note the `:record` mode is set to once. After you perform this spec, change the record mode to `:none`.

Subsequent runs of the specs should execute without need to connect to the Solr server. At this point, you may go to the
`andible-playbook-solrcloud` directory and stop SolrCloud instance with `make down`

## CI/CD

This project uses GitHub Actions for continuous integration and deployment.

### Continuous Integration
- **Lint and Test**: Runs on all pushes to feature branches (branches other than `main`)
  - Runs Rubocop for code linting
  - Runs Brakeman for security analysis
  - Runs RSpec test suite with SQLite3
  - Builds and compiles assets

### Deployments

#### QA Deploy
- **Trigger**: Pushes to `main` branch

#### Production Deploy  
- **Trigger**: Version tags matching `v*.*` pattern (e.g., `v1.0.0`, `v2.1`)
