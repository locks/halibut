module Halibut
  module HAL
    
    # Halibut::HAL::LinkSet handles all the logic of manipulating the links
    # associated with a certain resource.
    #
    class LinkSet
      include Enumerable

      # LinkSet can be initialized with an empty set. No problemo.
      # +links+ An array of links. LinkSet handles stuff from here.
      def initialize(links=[])
        @links = {}
        
        Array(links).each do |link|
          self << link
        end
        
      end
      
      # From enumerable
      def each
        return to_enum unless block_given?
        
        @links.values.uniq.each {|link| yield link }

        self
      end
      
      # from enumerable
      def <<(link)
        @links[link.relation] = link
      end
      
      # from enumerable
      def [](relation)
        @links[relation]
      end
      
      # from enumerable
      def []=(relation, link)
        @links[relation] = link
      end
      
      # from enumerable
      def empty?
        @links.empty?
      end
      
    end
    
  end
end