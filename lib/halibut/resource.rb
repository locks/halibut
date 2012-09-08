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
    
    #
    # Query
    #
    
    def embedded
      @resources
    end
    
    #
    # Serialize
    #
    def as_json
      json = {}
      json = json.merge @properties
      # json['_links']     = @links.to_hash.map {|k,v| {k => {'href' => v.to_hash}} }.reduce {} unless @links.empty?
      json['_links']     = {}.merge @links     unless @links.empty?
      json['_resources'] = {}.merge @resources unless @resources.empty?
      
      json
    end
    
    def to_json
      JSON.dump as_json
    end
    
  end
  
end