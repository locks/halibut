require 'uri_template'

module Halibut

  # Halibut::Link represents an HAL Link Object.
  # Properties:
  # * href
  # * templated
  # * type
  # * name
  # * profile
  # * title
  # * hreflang
  class Link
    attr_reader :type, :name, :profile,
                :title, :hreflang
    
    def initialize(href, templated=false, options={})
      @templated = templated
      
      set_href    href
      set_options options
    end
    
    def href
      @href.to_s
    end
    
    def templated?
      @templated
    end
    
    private
    def set_href(href)
      @href = @templated ? URITemplate.new(href) : URI(href)
    end
    
    def set_options(options)
      @type     = options[:title]
      @name     = options[:name]
      @profile  = options[:profile]
      @title    = options[:title]
      @hreflang = options[:hreflang]
    end
  end

end