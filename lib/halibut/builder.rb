require 'halibut/hal/resource'

module Halibut

  # Builder provides a very thin wrapper around creating a HAL resource.
  class Builder
    extend Forwardable

    attr_reader :resource

    def_delegator :@resource, :set_property,   :property
    def_delegator :@resource, :add_link,       :link
    def_delegator :@resource, :embed_resource, :embed

    def initialize(href=nil, &blk)
      @resource = Halibut::HAL::Resource.new href

      instance_eval(&blk) if block_given?
    end

    def relation(rel, &blk)
      RelationContext.new(@resource, rel, &blk)
    end

    private
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
