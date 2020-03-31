# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

  - In a separate project directory, clone the [Ansible Solr Cloud Playbook](https://github.com/tulibraries/ansible-playbook-solrcloud) project
  and follow the directions to create a SolrCloud container compatible with this project

  - Copy the Gencon50 CSV spreadsheets into the csv directory. The filename should be of the format name.csv.  Some of the csv files had multiple
  ".csv" extensions. There should only be one .csv extension. Rename the files accordingly

  - Seed the Solr database with the test data set.

    bundle exec bin/harvest_all.rb

* Database initialization

# Running the Tests

Tests require an instance of Solr to which to connect.

- In a separate project directory, clone the [Ansible Solr Cloud Playbook](https://github.com/tulibraries/ansible-playbook-solrcloud) project
and follow the directions to create a SolrCloud container compatible with this project

- Seed the Solr database with the test data set. Either:

  - Load the data from the command line

    bundle exec bin/csv2solr harvest csv/hold/2002.csv --mapfile=config/solr_map.yml --solr-url=http://localhost:8090/solr/gencon50

  - Load the data wiht the LOADSOLR option. Once the data is loaded, do not use this option

   LOADSOLR=y bundle exec rspec spec

- Run the tests

   bundle exec rspec spec

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
