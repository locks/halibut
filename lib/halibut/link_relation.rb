module Halibut

  # Domain object that represents a Relation
  #
  # spec spec spec.
  class LinkRelation
    attr_accessor :name, :curie

    def initialize(name)
      splits = name.to_s.split(":")

      splits.size < 2 ? @name = splits.first : (@curie, @name = splits)
    end

    def eql?(other)
      hash == other.hash
    end

    def hash
      instance_variables.hash
    end

    def to_s
      @curie and "#{@curie}:#{@name}" or @name
    end
  end
end
