module Halibut

  class Link
    attr_reader :href, :templated, :type, :name,
                :profile, :title, :hreflang
  
    def initialize(href, templated=nil, opts={})
      @href      = href
      @templated = templated
      
      set_options opts
    end
    
    def templated?
      @templated
    end
    
    def to_hash
      # hash = { 'href' => @href }
      # hash['templated'] = @templated unless @templated.nil?
      a = instance_variables.each_with_object({}) do |name, output|
        next if (ivar = instance_variable_get(name)).nil?
        
        output[name[1..-1]] = ivar
      end
      

      a
    end
    
    def to_s
      @href.to_s
    end
    
    
    private
    def set_options(opts)
      @type     = opts['type']
      @name     = opts['name']
      @profile  = opts['profile']
      @title    = opts['title']
      @hreflang = opts['hreflang']
    end
  end
  
end