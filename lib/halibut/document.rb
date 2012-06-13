module Halibut
  
  class Document
    attr_accessor :resources, :links
    
    def initialize(root, opts={})
      @options.merge(opts)
    end
    
  end
  
end