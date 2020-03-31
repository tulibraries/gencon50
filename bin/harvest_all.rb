#!/usr/bin/env ruby

files = Dir["csv/*.csv"]
files.each do |fn|
  fp = File.expand_path(fn)
  puts "process #{fp}"
  command = [
    "bundle",
    "exec",
    "bin/csv2solr",
    "harvest",
    "'#{fp}'",
    "--mapfile=config/solr_map.yml",
    "--solr-url=http://localhost:8090/solr/gencon50"].join(" ")
  puts command
  `#{command}`
end
