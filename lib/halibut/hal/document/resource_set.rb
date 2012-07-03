module Halibut
  module HAL

    class ResourceSet
      include Enumerable

      def initialize(resource=nil, resources=[])
        @document  = resource
        @resources = resources.dup
      end

      def each
        return to_enum unless block_given?

        @index.values.uniq.each {|link| yield resource }
      end
      
      def <<(resource)
        @resources << resource
      end

    end

  end
end