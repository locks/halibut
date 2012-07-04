require 'halibut/json/parser'

module Halibut
  
  # Halibut::JSON is responsible for handling serialization to the JSON format.
  module JSON
    
    # Alias for Halibut::JSON::Parser.parse
    def self.parse json
      Halibut::JSON::Parser.parse json
    end
    
  end
end