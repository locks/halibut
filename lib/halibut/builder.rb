require 'halibut/hal/resource'

module Halibut

  # Builder provides a very thin wrapper around creating a HAL resource.
  class Builder

    attr_reader :resource

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
    class RootContext
      extend Forwardable

      def_delegator :@resource, :set_property, :property
      def_delegator :@resource, :add_link,     :link

      def initialize(resource, &blk)
        @resource = resource

        instance_eval(&blk) if block_given?
      end

      def namespace(name, href)
        @resource.add_namespace(name, href)
      end

      def resource(rel, href=nil, &blk)
        embedded = Halibut::Builder.new(href, &blk)

        @resource.embed_resource(rel, embedded.resource)
      end

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