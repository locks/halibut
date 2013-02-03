require_relative 'spec_helper'


require 'hash'

describe Halibut::Builder do
  describe "Empty resource" do
    it "builds empty resource with no self link" do
      builder  = Halibut::Builder.new
      resource = Halibut::Core::Resource.new

      builder.resource.must_equal resource
    end

    it "builds empty resource with self link" do
      builder  = Halibut::Builder.new 'default'
      resource = Halibut::Core::Resource.new 'default'

      builder.resource.must_equal resource
    end
  end

  describe "Properties" do
    it "builds resource with a single property" do
      builder = Halibut::Builder.new do
        property 'foo', 'bar'
      end

      resource = Halibut::Core::Resource.new
      resource.set_property 'foo', 'bar'

      builder.resource.properties['foo'].must_equal 'bar'
      builder.resource.must_equal resource, diff(builder.resource.to_hash, resource.to_hash)
    end

    it "builds resource with several properties" do
      builder = Halibut::Builder.new do
        property 'foo', 'bar'
        property 'baz', 'quux'
        property 'medals', { gold: 1, silver: 5, bronze: 10 }
      end

      resource = Halibut::Core::Resource.new
      resource.set_property 'foo', 'bar'
      resource.set_property 'baz', 'quux'
      resource.set_property 'medals', { gold: 1, silver: 5, bronze: 10 }

      builder.resource.properties['foo'].must_equal 'bar'
      builder.resource.properties['baz'].must_equal 'quux'
      builder.resource.properties['medals'].must_equal({ gold: 1, silver: 5, bronze: 10 })

      builder.resource.must_equal resource, diff(builder.resource.to_hash, resource.to_hash)
    end

  end

  describe "Links" do
    it "builds resource with a single links per relation" do
      builder = Halibut::Builder.new do
        link 'cs:broms', '/broms/1'
        link 'cs:search', '/search{?broms,noms}', templated: true
      end

      resource = Halibut::Core::Resource.new
      resource.add_link 'cs:broms', '/broms/1'
      resource.add_link 'cs:search', '/search{?broms,noms}', templated: true

      resource.must_equal builder.resource, diff(builder.resource.to_hash, resource.to_hash)
    end

    it "builds resource with multiple links per relation" do
      builder = Halibut::Builder.new do
        link 'cs:broms', '/broms/1'
        link 'cs:broms', '/broms/2'
        link 'cs:search', '/search{?broms,noms}', templated: true
      end

      resource = Halibut::Core::Resource.new
      resource.add_link 'cs:broms', '/broms/1'
      resource.add_link 'cs:broms', '/broms/2'
      resource.add_link 'cs:search', '/search{?broms,noms}', templated: true

      resource.must_equal builder.resource, diff(builder.resource.to_hash, resource.to_hash)
    end
  end

  describe "Embedded resources" do
    it "builds resource with a single resource per relation" do
      builder = Halibut::Builder.new do
        resource 'games', '/game/1' do
          property :name,    'Crash Bandicoot'
          property :console, 'PlayStation'
        end
      end

      game = Halibut::Core::Resource.new '/game/1'
      game.set_property(:name, 'Crash Bandicoot')
      game.set_property(:console, 'PlayStation')

      resource = Halibut::Core::Resource.new
      resource.embed_resource('games', game)

      builder.resource.must_equal resource, diff(builder.resource.to_hash, resource.to_hash)
    end

    it "builds resource with multiple resourcer per relation" do
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

      game1 = Halibut::Core::Resource.new '/game/1'
      game1.set_property(:name, 'Crash Bandicoot')
      game1.set_property(:console, 'PlayStation')

      game2 = Halibut::Core::Resource.new '/game/2'
      game2.set_property(:name, 'Super Mario Land')
      game2.set_property(:console, 'Game Boy')

      resource = Halibut::Core::Resource.new
      resource.embed_resource('games', game1)
      resource.embed_resource('games', game2)

      builder.resource.must_equal resource, diff(builder.resource.to_hash, resource.to_hash)
    end
  end

  describe "Relation helper" do
    it "builds resource using relation DSL" do
      builder = Halibut::Builder.new do
        relation 'games' do
          link '/games/1'
          link '/games/2'
          link '/games/3'
        end
        link 'next', '/games/next'
        relation 'users' do
          resource '/users/1' do
            property :name, "foo"
            property :nick, "bar"
          end
        end
      end

      user = Halibut::Core::Resource.new '/users/1'
      user.set_property :name, "foo"
      user.set_property :nick, "bar"

      resource = Halibut::Core::Resource.new
      resource.add_link 'games', '/games/1'
      resource.add_link 'games', '/games/2'
      resource.add_link 'games', '/games/3'
      resource.add_link 'next', '/games/next'
      resource.embed_resource 'users', user

      builder.resource.must_equal resource, diff(builder.resource.to_hash, resource.to_hash)
    end
  end

  describe "Namespace helper" do
    let(:name) { 'cs' }
    let(:href) { 'http://cs-api.herokuapp.com/rels/{rel}' }

    it "builds resource using curie DSL" do
      builder = Halibut::Builder.new do
        namespace 'cs', 'http://cs-api.herokuapp.com/rels/{rel}'
      end

      curie = builder.resource.links['curie'].first

      curie.name.must_equal name
      curie.href.must_equal href
    end
  end

end
