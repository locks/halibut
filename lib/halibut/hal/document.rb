require 'halibut/hal/document/link_set'
require 'halibut/hal/document/resource_set'

module Halibut
  module HAL
  
    class Document
      attr_accessor :resources, :links
      
      def initialize(href, opts={})
        @options.merge(opts)
        
        @resources = ResourceSet.new(href)
        @links     = LinkSet.new
      end
    
    end

  end
end