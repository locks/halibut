require 'multi_json'

require 'halibut/core'

module Halibut::Adapter

  # This adapter converts Halibut::HAL::Resources to JSON encoded strings and back.
  #
  #     resource = Halibut::Builder.new('http://example.com') do
  #       link "posts", '/posts'
  #       link "author", 'http://locks.io'
  #
  #       property "title", 'Entry point'
  #     end.resource
  #
  #     dumped = Halibut::Adapter::JSON.dump resource
  #     # => "{\"title\":\"Entry point\",\"_links\":{\"self\":{\"href\":\"http://example.com\"},\"posts\":{\"href\":\"/posts\"},\"author\":{\"href\":\"http://locks.io\"}}}"
  #
  #     loaded = Halibut::Adapter::JSON.load dumped
  #     resource == loaded
  #     # => true
  #
  module JSON

    # Returns an Halibut::HAL::Resource from a JSON string
    def self.load(json)
      ResourceExtractor.new(json).resource
    end

    # Returns a JSON string representation of an Halibut::HAL::Resource
    def self.dump(resource)
      MultiJson.dump resource.to_hash
    end

    private
    def self.extended(base)
      base.extend InstanceMethods
    end

    module InstanceMethods
      def to_json
        MultiJson.dump self.to_hash
      end
    end

    class ResourceExtractor
      def initialize(json)
        @halibut = Halibut::Core::Resource.new
        @json    = MultiJson.load(json)

        extract_properties
        extract_links
        extract_embedded_resources
      end

      def resource
        @halibut
      end

      private
      def extract_properties
        properties = @json.reject {|k,v| k == '_links'    }
                          .reject {|k,v| k == '_embedded' }

        properties.each_pair do |property, value|
          @halibut.set_property(property, value)
        end
      end

      def extract_links
        links = @json.fetch('_links', [])

        links.each do |relation,values|
          link = ([] << values).flatten

          link.each do |attrs|
            href      = attrs.delete 'href'
            @halibut.add_link(relation, href, attrs)
          end
        end
      end

      def extract_embedded_resources
        resources = @json.fetch('_embedded', [])

        resources.each do |relation,values|
          embeds = ([] << values).flatten

          embeds.map  {|embed| MultiJson.dump embed                     }
                .map  {|embed| Halibut::Adapter::JSON.load embed        }
                .each {|embed| @halibut.embed_resource(relation, embed) }
        end
      end
    end
  end
end
