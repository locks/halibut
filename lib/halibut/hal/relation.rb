module Halibut

  class Relation
    attr_accessor :name, :curie

    def initialize(name)
      splits = name.split(":")

      splits.size < 2 ? @name = splits.first : (@curie, @name = splits)
    end

    def eql?(other)
      hash == other.hash
    end

    def hash
      instance_variables.hash
    end

    def to_s
      @name
    end

  end

end