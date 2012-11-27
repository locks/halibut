module Halibut

  # This is an abstract map with behaviour specific to HAL.
  #
  # spec spec spec
  class RelationMap
    extend Forwardable

    def_delegators :@relations, :[], :empty?, :==

    def initialize
      @relations = {}
    end

    # Adds an object to a relation.
    #
    # @param [String] relation relation that the object belongs to
    # @param [Object] item     the object to add to the relation
    def add(relation, item)
      @relations[relation] = @relations[relation].to_a << item
    end

    # Returns a hash corresponding to the object.
    #
    # RelationMap doens't just return @relations because it needs to convert
    # correctly when a relation only has a single item.
    #
    # @return [Hash] relation map in hash format
    def to_hash
      @relations.each_with_object({}) do |pair, obj|
        key, *value = pair.flatten

        key = key.to_s

        obj[key] = value.map &:to_hash
        obj[key].length == 1 and obj[key] = obj[key].first
      end
    end
  end
end