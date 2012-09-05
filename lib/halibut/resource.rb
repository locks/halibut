require 'halibut/link_relation'

module Halibut

  class Resource
    attr_reader :properties, :links
  
    def initialize(href=nil)
      @links = {}
      @resources = {}
      
      add_link('self', href) if href
    end
    
    def add_link(relation, href)
      if @links.has_key? relation
        @links[relation] = [] << @links[relation] << href
      else
        @links[relation] = href
      end
    end
    
    def embed_resource(relation, resource)
      if @resources.has_key? relation
        @resources[relation] = [] << @resources[relation] << resource
      else
        @resources[relation] = resource
      end
    end
    
    #
    # Query
    #
    
    def embedded
      @resources
    end
    
  end
  
end