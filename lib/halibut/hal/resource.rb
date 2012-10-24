require 'multi_json'
require 'halibut/relation_map'

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
    def add_link(relation, href, templated=nil, opts={})
      @links.add relation, Link.new(href, templated)
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

    # Rails convention.
    #
    # @return [Hash] hash representation of the resource
    def as_json
      json = {}
      json = json.merge @properties
      json['_links']     = {}.merge @links     unless @links.empty?
      json['_resources'] = {}.merge @resources unless @resources.empty?

      json
    end

    # Returns resource as HAL+JSON.
    #
    # @return [String] resource as HAL+JSON
    def to_json
      MultiJson.dump as_json
    end

    # Returns an Halibut::Resource with the data present in the JSON received.
    #
    # @param  [String] resource JSON object to be parsed.
    # @return [Halibut::HAL::Resource] resource generated from the data.
    def self.from_json(resource)
      json    = MultiJson.load(resource)
      halibut = self.new

      links     = json.delete '_links'
      resources = json.delete '_embedded'

      json.each_pair do |k,v|
        halibut.set_property k, v
      end

      links.each do |relation,v|
        link = [] << v
        link = link.flatten

        link.each do |attrs|
          href      = attrs.delete 'href'
          templated = attrs.delete 'templated'
          options   = attrs

          halibut.add_link relation, href, templated, options
        end
      end if links

      resources.each do |relation,value|
        res = [] << value
        res = res.flatten

        res.each do |resource|
          halibut.embed_resource relation, from_json(MultiJson.dump resource)
        end
      end if resources

      halibut
    end

    def ==(other)
      @properties == other.properties &&
      @links      == other.links      &&
      @resources  == other.embedded
    end
  end
end