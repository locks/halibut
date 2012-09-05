module Halibut

  class Resource
    attr_reader :properties, :links
  
    def initialize(href=nil)
      @links = {}
      @resources = {}
      
      add_link('self', href) if href
    end
    
    def add_link(relation, href)
      add_to_relation @links, relation, href
    end
    
    def embed_resource(relation, resource)
      add_to_relation @resources, relation, resource
    end
    
    #
    # Query
    #
    
    def embedded
      @resources
    end
    
    private
    def add_to_relation(collection, relation, item)
      if collection.has_key? relation
        collection[relation] = [] << collection[relation] << item
      else
        collection[relation] = item
      end
    end
    
  end
  
end