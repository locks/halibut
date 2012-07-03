require 'uri_template'

module Halibut
  module HAL
  
    # Halibut::HAL::Link implements a link element according to the HAL
    # property.
    # This class will be used in both JSON and XML formats to handle all
    # the logic and serializations.
    #
    # According to the spec, the following are required:
    # - relation
    # - href
    #
    # In addition there are also the following optional attributes:
    # - title
    # - hreflang
    # - templated (should the href be a URI template)
    #
    # Usage:
    #  Halibut::HAL::Link.new 'self', '/news'           # regular link
    #  Halibut::HAL::Link.new 'find', '/news{?search}'  # templated link
    #  Halibut::HAL::Link.new 'find', '/news{?search}', # link with all the
    #    :title     => "Search in German",              # options used
    #    :hreflang  => 'DE',
    #    :templated => true
    #
    class Link
      attr_reader :title, :hreflang
      
      def initialize(relation, href, options={})
        @name      = relation
        @href      = parse_href(href, options["templated"])
        
        @templated = options["templated"] || false
        @title     = options["title"]
        @hreflang  = options["hreflang"]
      end
      
      # Returns the href URI associated with this link element
      def href
        @href
      end
      alias_method :url, :href
      
      # Returns true if the element's href is a URI template, false otherwise
      def templated?
        @templated
      end
      
      # Returns the Link Relation for this link element
      def relation
        @name
      end
      alias_method :rel, :relation
      
      private
      
      def parse_href href, templated
        templated ? URITemplate.new(href) : URI.parse(href)
      end
    end
    
  end
end