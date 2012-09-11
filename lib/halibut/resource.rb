require 'json'
require 'halibut/relation_map'

module Halibut

  class Resource
    attr_reader :properties, :links

    def initialize(href=nil)
      @links      = RelationMap.new
      @resources  = RelationMap.new
      @properties = {}

      add_link('self', href) if href
    end

    def set_property property, value
      @properties[property] = value
    end

    def get_property property
      @properties[property]
    end

    def add_link(relation, href, templated=nil, opts={})
      @links.add relation, Halibut::Link.new(href, templated)
    end

    def embed_resource(relation, resource)
      @resources.add relation, resource
    end


    def embedded
      @resources
    end


    def as_json
      json = {}
      json = json.merge @properties
      json['_links']     = {}.merge @links     unless @links.empty?
      json['_resources'] = {}.merge @resources unless @resources.empty?

      json
    end

    def to_json
      JSON.dump as_json
    end

    def self.from_json resource
      json    = JSON.load(resource)
      halibut = Halibut::Resource.new

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
          halibut.embed_resource relation, Halibut::Resource.from_json(JSON.dump resource)
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