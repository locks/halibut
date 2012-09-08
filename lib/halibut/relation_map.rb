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
    
    def to_hash
      @relations.each_with_object({}) do |pair, obj|
        obj[pair.first] = pair[1..-1].map &:to_hash
        
        obj[pair.first] = obj[pair.first].first if obj[pair.first]
      end
    end
  
  end
  
end