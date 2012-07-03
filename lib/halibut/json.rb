require 'halibut/json/parser'

module Halibut
  module JSON
    
    def self.parse json
      Halibut::JSON::Parser.parse json
    end
    
  end
end