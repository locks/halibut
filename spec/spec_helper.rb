require 'bundler/setup'

require 'minitest/autorun'
require 'minitest/hell'

require 'halibut'

# Testing helper to load JSON files. Returns a string containing JSON.
def load_json(filename)
  File.read(File.dirname(__FILE__)+"/fixtures/#{filename}.json")
end

# Testing Helper to load XML files. Returns a string containing XML.
def load_xml(filename)
  File.read(File.dirname(__FILE__)+"/fixtures/xml/#{filename}.xml")
end

def load_resource(filename)
  File.read(File.dirname(__FILE__)+"/test-resources/src/main/resources/#{filename}")
end
