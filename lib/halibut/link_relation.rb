module Halibut

  # Domain object that represents a Relation
  #
  # spec spec spec.
  class LinkRelation
    attr_accessor :name, :curie

    # Initialize a `LinkRelation`.
    # A LinkRelation can be one of the relations registered, or use the
    # CURIE syntax to introduce a custom namespace. This syntax is
    # introduced by using the separator `:`.
    #
    # @example Simple LinkRelation
    #     Halibut::LinkRelation.new("author")
    #
    # @example CURIE syntax LinkRelation
    #     Halibut::LinkRelation.new("twitter:tweet")
    #
    # @param [String] name Name of the relation, with possible CURIE syntax.
    def initialize(name)
      splits = name.to_s.split(":")

      splits.size < 2 ? @name = splits.first : (@curie, @name = splits)
    end

    # Compares two `LinkRelation`s.
    #
    # @example
    #     one = Halibut::LinkRelation.new('lol')
    #     two = Halibut::LinkRelation.new('lol')
    #     one.eql?(two)
    #     # => true
    #
    # @param [LinkRelation] other LinkRelation to compare to
    def eql?(other)
      hash == other.hash
    end

    def hash
      instance_variables.hash
    end

    # Returns a custom formatted string representation of the object.
    #
    # @example Basic link relation
    #     Halibut::LinkRelation.new('lol').to_s
    #     # => "lol"
    #
    # @example Link relation with CURIE
    #     Halibut::LinkRelation.new('cs:lol').to_s
    #     # => "cs:lol"
    #
    # @return [String] name of the relation, optionally containing CURIE
    def to_s
      @curie and "#{@curie}:#{@name}" or @name
    end
  end
end
