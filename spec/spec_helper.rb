require 'bundler/setup'
Bundler.setup

require 'minitest/autorun'
require 'pry'
require 'halibut'

# Testing helper to load JSON files. Returns a string containing JSON.
def load_json(filename)
  File.read(File.dirname(__FILE__)+"/fixtures/#{filename}.json")
end

# Testing Helper to load XML files. Returns a string containing XML.
def load_xml(filename)
  File.read(File.dirname(__FILE__)+"/fixtures/xml/#{filename}.xml")
end