module Halibut::HAL

  # This class represents a HAL Link object.
  #
  # spec spec spec.
  class Link
    attr_reader :href, :templated, :type, :name,
                :profile, :title, :hreflang
  
    # Returns an instance of a HAL Link object
    #
    # @param [String]  href      URI or URI Template
    # @param [Boolean] templated true if URI Template or false otherwise
    # @param [Hash]    opts      Options: type, name, profile, title, hreflang
    #
    # @return [Halibut::HAL::Link] HAL Link object
    def initialize(href, templated=nil, opts={})
      @href      = href
      @templated = templated
      
      set_options opts
    end
    
    # Returns whether the href is a templated uri or not.
    #
    # Since all instance variables except href can be nil, 
    #
    # @return [true, false] whether the href is a templated uri or not.
    def templated?
      @templated || false
    end
    
    # Returns a hash corresponding to the Link object.
    #
    # @return [Hash] hash from Link Object
    def to_hash
      a = instance_variables.each_with_object({}) do |name, output|
        next if (ivar = instance_variable_get(name)).nil?
        
        output[name[1..-1]] = ivar
      end
    end
    
    def to_s
      @href
    end
    
    
    private
    def set_options(opts)
      @type     = opts[:type]
      @name     = opts[:name]
      @profile  = opts[:profile]
      @title    = opts[:title]
      @hreflang = opts[:hreflang]
    end
    
    def ==(other)
      @href      == other.href      &&
      @templated == other.templated &&
      @type      == other.type      &&
      @name      == other.name      &&
      @profile   == other.profile   &&
      @title     == other.title     &&
      @hreflang  == other.hreflang
    end
  end
  
end