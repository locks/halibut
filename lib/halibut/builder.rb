require 'halibut/hal/resource'

module Halibut

  # Builder provides a very thin wrapper around creating a HAL resource.
  class Builder
    extend Forwardable

    def initialize(href=nil, &blk)
      @resource = RootContext.new(href, &blk).build
    end

    def resource
      @resource
    end

    private
    class RootContext
      extend Forwardable

      def_delegator :@resource, :set_property, :property
      def_delegator :@resource, :add_link,     :link

      def initialize(href=nil, &blk)
        @resource = Halibut::HAL::Resource.new href

        instance_eval &blk if block_given?
      end

      def resource(rel, href=nil, &blk)
        embedded = Halibut::Builder.new href, &blk

        @resource.embed_resource rel, embedded.resource
      end

      def relation(rel, &blk)
        RelationContext.new(@resource, rel, &blk)
      end

      def build
        @resource
      end

    end

    class RelationContext

      def initialize(resource, rel, &blk)
        @resource = resource
        @rel      = rel

        instance_eval(&blk)
      end

      def link(href, opts={})
        @resource.add_link @rel, href, opts
      end
    end

  end

end
