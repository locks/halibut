module Halibut
  module HAL

    # Halibut::HAL::ResourceSet handles all the logic of manipulating the
    # embedded resources associated with a parent resource
    #
    class ResourceSet
      include Enumerable

      # Initialized a ResourceSet.
      # +resource+  The parent resource of this set.
      # +resoruces+ An array of resources.
      def initialize(resource=nil, resources=[])
        @document  = resource
        @resources = resources.dup
      end

      # from enumearble
      def each
        return to_enum unless block_given?

        @index.values.uniq.each {|link| yield resource }
      end
      
      # from enumerable
      def <<(resource)
        @resources << resource
      end

    end

  end
end