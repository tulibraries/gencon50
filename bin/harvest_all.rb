#!/usr/bin/env ruby

require 'dotenv/load'

Dotenv.load

files = Dir["csv/*.csv"]
files.sort.each do |fn|
  fp = File.expand_path(fn)
  puts "process #{fp}"
  command = [
    "bundle",
    "exec",
    "bin/csv2solr",
    "harvest",
    "'#{fp}'",
    "--mapfile=config/solr_map.yml",
    "--solr-url=#{ENV['SOLR_URL']}"].join(" ")
  puts command
  `#{command}`
end
