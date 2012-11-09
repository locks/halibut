module Halibut::HAL

  class Options
    attr_reader :templated, :type, :name,
                :profile, :title, :hreflang

    def initialize opts
      @templated = opts[:templated] || opts['templated']
      @type      = opts[:type]      || opts['type']
      @name      = opts[:name]      || opts['name']
      @profile   = opts[:profile]   || opts['profile']
      @title     = opts[:title]     || opts['title']
      @hreflang  = opts[:hreflang]  || opts['hreflang']
    end

    # Returns whether the href is a templated uri or not.
    #
    # Since all instance variables except href can be nil,
    #
    # @return [true, false] whether the href is a templated uri or not.
    def templated?
      @templated || false
    end

    def to_hash
      a = instance_variables.each_with_object({}) do |name, output|
        next if (ivar = instance_variable_get(name)).nil?

        output[name[1..-1]] = ivar
      end
    end
  end


  # This class represents a HAL Link object.
  #
  # spec spec spec.
  class Link
    extend Forwardable

    attr_reader :href

    def_delegators :@options, :templated, :templated?, :type,
                   :name, :profile, :title, :hreflang
    # Returns an instance of a HAL Link object
    #
    # @param [String]  href      URI or URI Template
    # @param [Boolean] templated true if URI Template or false otherwise
    # @param [Hash]    opts      Options: type, name, profile, title, hreflang
    #
    # @return [Halibut::HAL::Link] HAL Link object
    def initialize(href, opts={})
      @href = href
      @options = Options.new opts
    end

    # Returns a hash corresponding to the Link object.
    #
    # @return [Hash] hash from Link Object
    def to_hash
      { 'href' => href }.merge @options.to_hash
    end

    def to_s
      @href
    end

    def ==(other)
      @href == other.href #&& @options == other.options
    end

    protected
    attr_reader :options

  end

end