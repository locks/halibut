module Halibut

  class RelationMap
  
    def initialize
      @relations = {}
    end
    
    def add(relation, item)
      @relations[relation] = [] unless @relations.has_key? relation
      
      @relations[relation] << item
    end
    
    def [](relation)
      @relations[relation]
    end
    
    def empty?
      @relations.empty?
    end
    
    def to_hash
      a = @relations.each_with_object({}) do |pair, obj|
        key, *value = pair.flatten
        
        obj[key] = value.map &:to_hash
        obj[key].length == 1 and obj[key] = obj[key].first
      end
      
    end
    
    def ==(other)
      @relations == other.instance_variable_get(:@relations)
    end
  
  end
  
end