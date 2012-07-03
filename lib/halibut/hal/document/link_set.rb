module Halibut
  
  module HAL
    
    class LinkSet
      include Enumerable
      
      attr_reader :links
      
      def initialize(links=[])
        @links = {}
        
        Array(links).each do |link|
          self << link
        end
        
      end
      
      def each
        return to_enum unless block_given?
        
        @links.values.uniq.each {|link| yield link }

        self
      end
      
      def <<(link)
        @links[link.relation] = link
      end
      
      def [](relation)
        @links[relation]
      end
      
      def []=(relation, link)
        @links[relation] = link
      end
      
      def empty?
        @links.empty?
      end
      
    end
    
  end
  
end