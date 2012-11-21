require 'halibut/hal/resource'

module Halibut

  # Builder provides a very thin wrapper around creating a HAL resource.
  class Builder
    extend Forwardable

    def_delegator :@resource, :set_property, :property
    def_delegator :@resource, :add_link    , :link

    def initialize(href=nil, &blk)
      @resource = Halibut::HAL::Resource.new href

      instance_eval(&blk) if block_given?
    end

    def resource
      @resource
    end

  end

end
