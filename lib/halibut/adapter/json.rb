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
    #
    # @param [StringIO] json the JSON to parse
    def self.parse(json)
      ResourceExtractor.new(json).resource
    end

    # Returns a JSON string representation of an Halibut::HAL::Resource
    def self.dump(resource)
      MultiJson.dump resource.to_hash
    end

    private

    # @deprecated Please use Halibut::Adapter::JSON.dump instead.
    def self.extended(base)
      base.extend InstanceMethods
    end

    module InstanceMethods
      # @deprecated This might go.
      def to_json
        warn "[Deprecation] Don't depend on this, as it might disappear soon."
        MultiJson.dump self.to_hash
      end
    end

    # ResourceExtractor is responsible for deserializing an HAL resource
    # from the JSON representation.
    #
    #     extractor = ResourceExtractor.new({})
    #     # => #<Halibut::Adapter::JSON::ResourceExtractor:0x007f8adb92f2a8
    #     extractor.resource
    #     # => #<Halibut::HAL::Resource:0x007f8add058fb0
    #
    class ResourceExtractor

      # Straight-forward, just pass in the JSON string you want to extract the
      # resource from.
      #
      #     json = '{"_links":{"self":{"href":"http://example.com"}}}'
      #     ResourceExtractor.new('{}')
      #
      # @param [StringIO] json the json from which to extract the resource
      def initialize(json)
        @halibut = Halibut::Core::Resource.new
        @json    = MultiJson.load(json)

        extract_properties
        extract_links
        extract_embedded_resources
      end

      # This method should be called when the the resource extracted is needed
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
                .map  {|embed| Halibut::Adapter::JSON.parse embed       }
                .each {|embed| @halibut.embed_resource(relation, embed) }
        end
      end
    end

    module ConvenienceMethods
      def parse_json(json_str_or_io)
        Halibut::Adapter::JSON.parse(json_str_or_io)
      end
    end
  end
end
