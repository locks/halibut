require 'nokogiri'

module Halibut::Adapter

  module XML
    def self.extended(base)
      base.extend InstanceMethods
    end

    def self.load(xml)
      ResourceExtractor.new(xml).resource
    end

    def self.dump(resource)
    end

    private
    module InstanceMethods
      def to_xml
      end
    end

    class ResourceExtractor
      def initialize(xml)
        xml = Nokogiri::XML(xml)

        @document = xml.root
        @halibut  = Halibut::HAL::Resource.new extract_self_link

        # binding.pry

        extract_curie
        extract_properties
        extract_links
        extract_resources
      end

      def resource
        @halibut
      end

      private
      def extract_self_link
        @document.attr 'href'
      end

      def extract_curie
        @document.namespace_scopes
                 .reject {|ns| ns.prefix.eql? 'xsi' }
                 .each do |ns|
          @halibut.add_link 'curie', ns.href, name: ns.prefix
        end
      end

      def extract_properties
        properties = @document.xpath '/resource/*[not(self::link) and not(self::resource)]'

        properties.each do |property|
          @halibut.set_property property.name, property.content
        end
      end

      def extract_links
        links = @document.xpath('/resource/link')

        links.each do |link|
          @halibut.add_link link.attribute('rel').value,
                            link.attribute('href').value,
                            extract_link_options(link)
        end
      end

      # In case there are no options on the link, it returns an empty hash
      def extract_link_options(link)
        link.attributes.reject {|k,v| k=='rel' || k=='href' }
            .map    {|k,v| { k => v.value } }
            .reduce(:merge) || {}
      end

      def extract_resources
        @document.xpath('/resource/resource')
                 .map  {|r| [] << r['rel'] << ResourceExtractor.new(r.to_xml).resource }
                 .each {|rel,res| @halibut.embed_resource rel, res }
      end
    end
  end

end