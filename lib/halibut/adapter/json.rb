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
        @halibut = Halibut::HAL::Resource.new
        json     = MultiJson.load(json)

        links      = json.delete '_links'
        resources  = json.delete '_embedded'
        properties = json

        properties and extract_properties properties
        links      and extract_links      links
        resources  and extract_resources  resources
      end

      def resource
        @halibut
      end

      private
      def extract_properties(properties)
        properties.each_pair do |property, value|
          @halibut.set_property(property, value)
        end
      end

      def extract_links(links)
        links.each do |relation,values|
          links = ([] << values).flatten

          links.each do |attrs|
            href      = attrs.delete 'href'
            @halibut.add_link(relation, href, attrs)
          end
        end
      end

      def extract_resources(resources)
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