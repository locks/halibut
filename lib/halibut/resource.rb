require 'halibut/relation_map'

module Halibut

  class Resource
    attr_reader :properties, :links
  
    def initialize(href=nil)
      @links = RelationMap.new
      @resources = RelationMap.new
      
      add_link('self', href) if href
    end
    
    def add_link(relation, href)
      @links.add relation, href
    end
    
    def embed_resource(relation, resource)
      @resources.add relation, resource
    end
    
    #
    # Query
    #
    
    def embedded
      @resources
    end
    
  end
  
end