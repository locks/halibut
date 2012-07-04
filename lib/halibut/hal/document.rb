require 'halibut/hal/document/link_set'
require 'halibut/hal/document/resource_set'

module Halibut
  module HAL
  
    # Halibut::HAL::Document represents a document. Will probably be removed
    # in favour of Halibut::HAL::Resource
    #
    class Document
      # +resources+ ResourceSet associated with the document
      # +links+     LinkSet associated with the document
      attr_accessor :resources, :links
      
      # Initializes the Document
      # +href+ The URI of this document
      # +opts+ Right...
      def initialize(href, opts={})
        @options.merge(opts)
        
        @resources = ResourceSet.new(href)
        @links     = LinkSet.new
      end
    
    end

  end
end