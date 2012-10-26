module Halibut

  class Relation

    def initialize(name)
      @name = name

      binding.pry
    end

    def eql?(other)
      hash == other.hash
    end

    def hash
      instance_variables.hash
    end

  end

end