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
    attr_reader :href, :templated, :type, :name,
                :profile, :title, :hreflang
    
    def new(href, templated=nil, options={})
      set_uri     href, templated
      set_options options
    end
    
    private
    def set_uri(href, templated)
      binding.pry
      @href = templated ? URITemplate.new(href) : URI(href)
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