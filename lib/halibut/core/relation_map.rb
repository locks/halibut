module Halibut::Core

  # This is an abstract map with behaviour specific to HAL.
  #
  # spec spec spec
  class RelationMap
    extend Forwardable

    def_delegators :@relations, :[], :empty?, :==, :fetch

    def initialize
      @relations = {}
    end

    # Adds an object to a relation.
    #
    #     relations = RelationMap.new
    #     relations.add 'self', Link.new('/resource/1')
    #     relations['self']
    #     # => [#<Halibut::Core::Link:0x007fa0ca5b92b8 @href=\"/resource/1\",
    #          @options=#<Halibut::Core::Link::Options:0x007fa0ca5b9240
    #          @templated=nil, @type=nil, @name=nil, @profile=nil,
    #          @title=nil, @hreflang=nil>>]
    #
    # @param [String] relation relation that the object belongs to
    # @param [Object] item     the object to add to the relation
    def add(relation, item)
      @relations[relation] = @relations.fetch(relation, []) << item
    end

    # Returns a hash corresponding to the object.
    #
    # RelationMap doens't just return @relations because it needs to convert
    # correctly when a relation only has a single item.
    #
    # @return [Hash] relation map in hash format
    def to_hash
      @relations.each_with_object({}) do |(rel,val), obj|
        rel = rel.to_s
        val = val.length == 1 ? val.first.to_hash : val.map(&:to_hash)

        obj[rel] = val
      end
    end
  end
end
