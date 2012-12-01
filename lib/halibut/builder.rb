require 'halibut/hal/resource'

module Halibut

  # Builder provides a very thin wrapper around creating a HAL resource.
  class Builder

    # The HAL resource built
    attr_reader :resource

    #
    #
    # @param [String] href
    # @param [Proc]   blk
    def initialize(href=nil, &blk)
      @resource = Halibut::HAL::Resource.new href

      RootContext.new(@resource, &blk)
    end

    def respond_to?(meth, *args)
      RootContext.new(@resource).respond_to? meth
    end

    def method_missing meth, *args
      RootContext.new(@resource).send meth, *args
    end

    private

    # This is the root context of Halibut::Builder.
    #
    #
    class RootContext
      extend Forwardable

      def_delegator :@resource, :set_property, :property
      def_delegator :@resource, :add_link,     :link

      def initialize(resource, &blk)
        @resource = resource

        instance_eval(&blk) if block_given?
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
        @resource.add_link(@rel, href, opts)
      end

      def resource(href=nil, &blk)
        embedded = Halibut::Builder.new(href, &blk)

        @resource.embed_resource(@rel, embedded.resource)
      end
    end

  end

end