require 'bundler/setup'
Bundler.setup

require 'minitest/autorun'
require 'pry'
require 'halibut'

def load_fixture(filename)
  File.read(File.dirname(__FILE__)+"/fixtures/#{filename}")
end