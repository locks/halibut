require_relative 'spec_helper'

describe Halibut::Builder do

  it "builds empty resource" do
    builder  = Halibut::Builder.new
    resource = Halibut::HAL::Resource.new

    builder.resource.must_equal resource
  end

  it "builds resource with default link" do
    builder  = Halibut::Builder.new 'default'
    resource = Halibut::HAL::Resource.new 'default'

    builder.resource.must_equal resource
  end

  it "builds resource with links" do
    builder = Halibut::Builder.new do
      link 'cs:broms', '/broms/1'
      link 'cs:broms', '/broms/2'
      link 'cs:search', '/search{?broms,noms}', templated: true
    end

    resource = Halibut::HAL::Resource.new
    resource.add_link 'cs:broms', '/broms/1'
    resource.add_link 'cs:broms', '/broms/2'
    resource.add_link 'cs:search', '/search{?broms,noms}', templated: true

    resource.must_equal builder.resource
  end

  it "builds resource with properties" do
    builder = Halibut::Builder.new do
      property 'foo', 'bar'
      property 'baz', 'quux'
    end

    resource = Halibut::HAL::Resource.new
    resource.set_property 'foo', 'bar'
    resource.set_property 'baz', 'quux'

    resource.must_equal builder.resource
  end

  it "builds resource with embedded resources" do
    skip "Shouldn't be any harder that the rest"
  end

  describe "Relations" do

    it "builds resource using relation DSL" do
      builder = Halibut::Builder.new do
        relation 'games' do
          link '/games/1'
          link '/games/2'
          link '/games/3'
        end
        link 'next', '/games/next'
      end

      resource = Halibut::HAL::Resource.new
      resource.add_link 'games', '/games/1'
      resource.add_link 'games', '/games/2'
      resource.add_link 'games', '/games/3'
      resource.add_link 'next', '/games/next'

      builder.resource.must_equal resource
    end

  end

end
