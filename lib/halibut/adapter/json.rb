require 'multi_json'

module Halibut::Adapter

  module JSON
    def self.load(json)
      ResourceExtractor.new(json).resource
    end

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
