module Halibut

  class RelationMap
  
    def initialize
      @relations = {}
    end
    
    def add(relation, item)
      if @relations.has_key? relation
        @relations[relation] = [] << @relations[relation] << item
      else
        @relations[relation] = item
      end
    end
    
    def [](relation)
      @relations[relation]
    end
    
    def empty?
      @relations.empty?
    end
  
  end
  
end