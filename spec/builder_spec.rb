require_relative 'spec_helper'


require 'hash'

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

  describe "Embedded resources" do
    it "embeds a single resource" do
      builder = Halibut::Builder.new do
        resource 'games', '/game/1' do
          property :name,    'Crash Bandicoot'
          property :console, 'PlayStation'
        end
      end

      game = Halibut::HAL::Resource.new '/game/1'
      game.set_property(:name, 'Crash Bandicoot')
      game.set_property(:console, 'PlayStation')

      resource = Halibut::HAL::Resource.new
      resource.embed_resource('games', game)

      builder.resource.must_equal resource, diff(builder.resource.to_hash, resource.to_hash)
    end

    it "embeds a collection of resources" do
      builder = Halibut::Builder.new do
        resource 'games', '/game/1' do
          property :name,    'Crash Bandicoot'
          property :console, 'PlayStation'
        end
        resource 'games', '/game/2' do
          property :name,    'Super Mario Land'
          property :console, 'Game Boy'
        end
      end

      game1 = Halibut::HAL::Resource.new '/game/1'
      game1.set_property(:name, 'Crash Bandicoot')
      game1.set_property(:console, 'PlayStation')

      game2 = Halibut::HAL::Resource.new '/game/2'
      game2.set_property(:name, 'Super Mario Land')
      game2.set_property(:console, 'Game Boy')

      resource = Halibut::HAL::Resource.new
      resource.embed_resource('games', game1)
      resource.embed_resource('games', game2)

      builder.resource.must_equal resource, diff(builder.resource.to_hash, resource.to_hash)
    end
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
