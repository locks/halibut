require 'halibut/json/parser'

module Halibut

  # Halibut::XML is responsible for handling serialization to the XML format.
  module XML

    # Alias for Halibut::XML::Parser.parse
    def self.parse json
      Halibut::JSON::Parser.parse json
    end

  end
end