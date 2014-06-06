require 'halibut/core/resource'

module Halibut

  # Builder provides a very thin wrapper around creating a HAL resource.
  class Builder

    # Initializes a Builder object.
    # Optionally receives an href pointing to the representation
    # and a block containing DSL methods to build the resource.
    #
    # @param [String] href optional URI for the resource
    # @param [Proc] resource_definition DSL methods to build the resource
    def initialize(href=nil, &resource_definition)
      @resource = Halibut::Core::Resource.new href

      RootContext.new(@resource, &resource_definition)
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

      # Sets up the root context for the DSL methods.
      #
      # @param [Halibut::Core::Resource] resource resource to be built
      # @param [Proc] resource_definition DSL methods to build the resource
      def initialize(resource, &resource_definition)
        @resource = resource

        instance_eval(&resource_definition) if block_given?
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
      # @example Adds a namespace "john" to the resource
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
      # @example Builds a resource with name and nick properties
      #     resource = Halibut::Builder.new do
      #       resource '/users/1' do
      #         property :name, "foo"
      #         property :nick, "bar"
      #       end
      #     end
      #
      # @param [String] rel  Embedded resource relation to the parent resource
      # @param [String] href URI to the resource itself
      # @param [Proc]   embedded_definition Instructions to construct the embedded resource
      def resource(rel, href=nil, &embedded_definition)
        embedded = Halibut::Builder.new(href, &embedded_definition)

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
      # @param [Proc]          relation_definition Instructions to be executed
      #                        in the relation context
      # @return [RelationContext]
      def relation(rel, &relation_definition)
        RelationContext.new(@resource, rel, &relation_definition)
      end
    end

    class RelationContext

      # Evaluates the DSL methods in the context of a relation.
      #
      # @param [Halibut::Core::Resource] resource the resource to which
      #                                  properties will be added.
      # @param [String] rel relation to which the resource will be added.
      # @param [Proc] relation_definition a block with DSL methods
      def initialize(resource, rel, &relation_definition)
        @resource = resource
        @rel      = rel

        instance_eval(&relation_definition) if block_given?
      end

      # Adds a link to the resource for the parent relation.
      # Since we're in the context of a relation, only the href and the
      # options are necessary.
      #
      # @example Builds a resource with a link to a `games` relation.
      #     builder = Halibut::Builder.new do
      #       relation 'games' do
      #         link '/games/1'
      #       end
      #     end
      #
      # @param [String] href href associated with the link
      # @param [Hash] opts options associated with the link
      def link(href, opts={})
        @resource.tap {|obj| obj.add_link(@rel, href, opts) }
      end

      # Adds an embedded resource for the parent relation.
      # Since we're in the context of a relation, only the href and the
      # resource definition is necessary.
      #
      # @example Builds a resource with an embedded user for the `users`
      #          relation.
      #     builder = Halibut::Builder.new do
      #       relation 'users' do
      #         resource '/users/1' do
      #           property :name, "foo"
      #           property :nick, "bar"
      #         end
      #       end
      #     end
      #
      # @param [String] href href associated with the link
      # @param [Proc] embedded_definition resource DSL methods
      def resource(href=nil, &embedded_definition)
        embedded = Halibut::Builder.new(href, &embedded_definition)

        @resource.embed_resource(@rel, embedded.resource)
      end
    end
  end
end
