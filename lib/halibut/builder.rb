require 'halibut/core/resource'

module Halibut

  # Builder provides a very thin wrapper around creating a HAL resource.
  class Builder

    #
    #
    # @param [String] href
    # @param [Proc]   blk
    def initialize(href=nil, &blk)
      @resource = Halibut::Core::Resource.new href

      RootContext.new(@resource, &blk)
    end

    # Returns the resource built.
    #
    # @return [Halibut::Core::Resource] resource built with the DSL
    def resource
      @resource
    end

    private
    # This is the root context of Halibut::Builder.
    #
    #
    class RootContext

      def initialize(resource, &blk)
        @resource = resource

        instance_eval(&blk) if block_given?
      end

      # Sets a property on the resource.
      # Will overwrite any same-named existing property.
      #
      # @param [String] name  name of the property
      # @param [String] value value of the property
      # @return [Halibut::Core::resource] resource with property set
      def property(name, value)
        @resource.set_property name, value
      end

      # Adds a link to the respection relation of the resource.
      #
      # @param [String] relation relation to which link will be added
      # @param [String] href     URI of the link
      # @param [Hash]   options  Link optional parameters: templated, hreflang, etc
      # @return [Halibut::Core::Resource] resource with the link added
      def link(relation, href, options={})
        @resource.add_link relation, href, options
      end

      # Adds a namespace to the resource.
      #
      # A namespace is a conceptual abstraction of CURIE links.
      # Since the client of the library doesn't need to handle CURIE links
      # directly because they're just for dereferencing link relations, no
      # CURIE links are presented.
      #
      #     resource = Halibut::Builder.new do
      #       namespace :john, 'http://appleseed.com'
      #     end.resource
      #     resource.namespace(:john).href
      #     # => "http://appleseed.com"
      #
      # @param [String,Symbol] name name of the namespace
      # @param [String]        href URI of the namespace
      def namespace(name, href)
        @resource.add_namespace(name, href)
      end

      # Adds an embedded resource.
      #
      # @param [String] rel  Embedded resource relation to the parent resource
      # @param [String] href URI to the resource itself
      # @param [Proc]   blk  Instructions to construct the embedded resource
      def resource(rel, href=nil, &blk)
        embedded = Halibut::Builder.new(href, &blk)

        @resource.embed_resource(rel, embedded.resource)
      end

      # Adds links or resources to a relation.
      #
      # Relation allows the user to specify links, or resources, per relation,
      # instead of individually.
      # This feature was introduced as an attempt to reduce repeating the
      # relation per link/resource, and thus reducing typos.
      #
      #     resource = Halibut::Builder.new do
      #       relation :john do
      #         link 'http://appleseed.com/john'
      #       end
      #     end.resource
      #     resource.links[:john].first.href
      #
      # @param [String,Symbol] rel
      # @param [Proc]          blk Instructions to be executed in the relation
      #                            context
      def relation(rel, &blk)
        RelationContext.new(@resource, rel, &blk)
      end
    end

    class RelationContext

      def initialize(resource, rel, &blk)
        @resource = resource
        @rel      = rel

        instance_eval(&blk) if block_given?
      end

      def link(href, opts={})
        @resource.tap {|obj| obj.add_link(@rel, href, opts) }
      end

      def resource(href=nil, &blk)
        embedded = Halibut::Builder.new(href, &blk)

        @resource.embed_resource(@rel, embedded.resource)
      end
    end

  end
end
