#!/usr/bin/env ruby

files = Dir["csv/*.csv"]
files.each do |fn|
  fp = File.expand_path(fn)
  puts "process #{fp}"
  command = [
    "bundle",
    "exec",
    "csv2solr",
    "harvest",
    "'#{fp}'",
    "--mapfile=config/solr_map.yml",
    "--solr-url=http://localhost:8983/solr/blacklight-core"].join(" ")
  puts command
  `#{command}`
end
