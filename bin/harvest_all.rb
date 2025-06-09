#!/usr/bin/env ruby

require 'dotenv/load'
require 'logger'

Dotenv.load

logger = Logger.new(STDOUT)
files = Dir["csv/*.csv"]
files.sort.each do |fn|
  fp = File.expand_path(fn)
  logger.info("Processing #{fp}")
  command = [
    "bundle",
    "exec",
    "bin/csv2solr",
    "harvest",
    "'#{fp}'",
    "--mapfile=config/solr_map.yml",
    "--solr-url=#{ENV['SOLR_URL']}"].join(" ")
  logger.info("Executing command: #{command}")
  output = `#{command}`
  if $?.exitstatus != 0
    logger.error("Command failed with status #{$?.exitstatus}")
    logger.error("Output: #{output}")
  else
    logger.info("Command succeeded")
  end
end