module Halibut

  # This is an abstract map with behaviour specific to HAL.
  #
  # spec spec spec
  class RelationMap

    extend Forwardable

    def_delegators :@relations, :[], :empty?

    def initialize
      @relations = {}
    end

    # Adds an object to a relation.
    #
    # @param [String] relation relation that the object belongs to
    # @param [Object] item     the object to add to the relation
    def add(relation, item)
      @relations[relation] = [] unless @relations.has_key? relation

      @relations[relation] << item
    end

    # Returns a hash corresponding to the object.
    #
    # @return [Hash] relation map in hash format
    def to_hash
      a = @relations.each_with_object({}) do |pair, obj|
        key, *value = pair.flatten

        obj[key] = value.map &:to_hash
        obj[key].length == 1 and obj[key] = obj[key].first
      end

    end

    # Compares two relation sets
    #
    # @param [Halibut::RelationMap] other relation map
    # @return [true, false] whether the two relation maps have the same relations
    #   and relation items
    def ==(other)
      @relations == other.instance_variable_get(:@relations)
    end

  end

end