require 'halibut/hal/document/link_set'

module Halibut
  module HAL
  
    # Halibut::HAL::Resource is the main entry point to dealing with HAL
    # documents.
    # This class will be used in both JSON and XML formats to handle all
    # the logic and serializations.
    #
    # According to the spec, the following are required:
    #   - link to self
    #
    # In addition, there are also the following optinal attributes:
    #   - resource properties
    #   - embedded resources
    #   - other links
    class Resource
      # Resource attributes:
      # +resources+ Embedded resources
      # +links*     Links associated with this resource
      attr_reader :resources, :links
      
      # Initializes Resource.
      # +href+
      # +links+
      # +resources+
      def initialize(href, links={}, resources=[])
        @links      = LinkSet.new
        @resources  = ResourceSet.new
        
        @links << Halibut::HAL::Link.new('self', href)
      end
      
      # Returns the URI associated with this resource
      def href
        @links[:self]
      end
      alias_method :href, :url
      
      # Returns the URI associated with this resource
      def url
        @links['self'].url
      end
      
    end

  end
end