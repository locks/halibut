module Halibut::Core
  # This class represents a HAL Link object.
  #
  # spec spec spec.
  class Link
    extend Forwardable

    # The URI associated with this link.
    attr_reader :href

    def_delegators :@options, :templated, :templated?, :type,
                   :name, :profile, :title, :hreflang

    # Returns an instance of a HAL Link object
    #
    #     # link with no options
    #     link = Link.new('http://homeopathy.org')
    #
    #     # link with name and type options
    #     link = Link.new('http://homeopathy.org', name: 'Homeopath'
    #                                            , type: 'text/html')
    #
    # If you pass an options that is not one of the reserved link properties
    # as defined by the spec, they are dropped.
    # It should possibly raise an error, hafta think about it.
    #
    # @param [String]  href      URI or URI Template
    # @param [Hash]    opts      Options: type, name, profile, title, hreflang
    #
    # @return [Halibut::Core::Link] HAL Link object
    def initialize(href, opts={})
      @href    = href
      @options = Options.new opts
    end

    # Simply returns a hash of the href and the options that are not empty.
    #
    #     link = Link.new('/links', name: 'Links')
    #     link.to_hash
    #     # => { "href" => "/links", "name" => "links" }
    #
    # @return [Hash] hash from Link Object
    def to_hash
      { 'href' => href }.merge @options
    end

    # Generic comparison method.
    #
    # Two objects are the same if they have the same href and the same options.
    #
    #     link_one = Link.new('/link', name: 'One', type: 'text/html')
    #     link_two = Link.new('/link', name: 'One', type: 'text/html')
    #     link_one == link_two
    #     # => true
    #
    # @param [Link] other Link object to compare to
    # @return [true,false] return of the comparison of the two objects
    def ==(other)
      @href == other.href && @options == other.options
    end

    protected
    attr_reader :options

    private
    # Options reifies the various optional properties of a link, as per the
    # spec: templated, type, name, profile, title, hreflang.
    #
    #     hash = { name: 'John le Carré', templated: true }
    #     opts = Options.new(hash)
    #     opts.name    # => John le Carré
    #     opts['name'] # => John le Carré
    #     opts[:name]  # => John le Carré
    #
    class Options
      attr_reader :templated, :type, :name,
                  :profile, :title, :hreflang

      def initialize opts
        string_options = Helpers::stringify_keys(opts)

        @templated = opts[:templated] || opts['templated']
        @type      = opts[:type]      || opts['type']
        @name      = opts[:name]      || opts['name']
        @profile   = opts[:profile]   || opts['profile']
        @title     = opts[:title]     || opts['title']
        @hreflang  = opts[:hreflang]  || opts['hreflang']
      end

      # Tells us if the href of the associated link is templated.
      #
      # The reason for not returning @templated directly is that all of the
      # options are optional, thus nil could be returned instead of a boolean.
      #
      # @return [true, false] whether the href is a templated uri or not.
      def templated?
        @templated || false
      end

      # When converting to a hash, options that weren't set (.nil? == true) are
      # kept out.
      #
      # This might have some implications, as it does not 'serialiaze' options
      # that were explicitely set to nil. On the other hand, one can argue that
      # if they were explicitly set to nil, then they shouldn't show up anyway.
      def to_hash
        instance_variables.each_with_object({}) do |ivar, hash|
          name  = ivar.to_s.reverse.chomp("@").reverse
          value = instance_variable_get(ivar)

          next if value.nil?

          hash[name] = value
        end
      end

      # Straight forward comparison between two Options objects.
      #
      #     opts_one = Options.new(name: 'Link', templated: true)
      #     opts_two = Options.new(name: 'Link', templated: true)
      #     opts_one == opts_two
      #     # => true
      #
      # @param [Options] other Options object to compare to.
      # @return [true,false] whether these two objects are equivalent or not.
      def ==(other)
        to_hash == other.to_hash
      end

      private
      module Helpers
        def self.stringify_keys(hash)
          hash.each_with_object({}) {|(k,v), obj| obj[k.to_s] = v }
        end
      end
    end
  end

end
