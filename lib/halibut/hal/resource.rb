require 'multi_json'

require 'halibut/hal/link'
require 'halibut/relation_map'
require 'halibut/adapter/json'

module Halibut::HAL

  # This class represents a HAL Resource object.
  #
  # spec spec spec
  class Resource
    attr_reader :properties, :links

    # TDK
    #
    # @param [String] href Link that will be added to the self relation.
    def initialize(href=nil)
      @links      = Halibut::RelationMap.new
      @resources  = Halibut::RelationMap.new
      @properties = {}

      add_link('self', href) if href
    end

    # TDK
    #
    # @param [Object] property the key
    # @param [Object] value    the value
    def set_property(property, value)
      @properties[property] = value
    end

    # Returns the value of a property in the resource
    #
    # @param [String] property property
    def get_property property
      @properties[property]
    end

    # Adds link to relation
    #
    # @param [String]      relation  relation
    # @param [String]      href      href
    # @param [true, false] templated templated
    # @param [Hash]        opts      options: name, type, hreflang
    def add_link(relation, href, opts={})
      @links.add relation, Link.new(href, opts)
    end

    # Embeds resource in relation
    #
    # @param [String]   relation relation
    # @param [Resource] resource resource to embed
    def embed_resource(relation, resource)
      @resources.add relation, resource
    end

    # Returns all embedded relations and their resources
    #
    # @return [Halibut::ResourceMap] embedded resources by relation
    def embedded
      @resources
    end

    # Hash representation of the resource.
    # Will ommit links and embedded keys if they're empty
    #
    # @return [Hash] hash representation of the resource
    def to_hash
      {}.merge(@properties).tap do |h|
        h['_links']    = {}.merge @links     unless @links.empty?
        h['_embedded'] = {}.merge @resources unless @resources.empty?
      end
    end

    # Compares two resources.
    #
    # @param  [Halibut::HAL::Resource] other Resource to compare to
    # @return [true, false]                  Result of the comparison
    def ==(other)
      @properties == other.properties &&
      @links      == other.links      &&
      @resources  == other.embedded
    end
  end
end