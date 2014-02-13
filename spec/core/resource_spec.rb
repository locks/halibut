require_relative '../spec_helper'

require 'halibut/core/resource'

describe Halibut::Core::Resource do
  subject { Halibut::Core::Resource.new }
  let(:templated_uri) { "http://example.com/{path}{?query}" }
  let(:normal_uri)    { "http://example.com" }

  describe "Properties" do
    it "set property" do
      subject.set_property "property", "value"

      subject.properties['property'].must_equal "value"
    end

    it "fails to set reserved property" do
      -> { subject.set_property "_links", "lol" }.must_raise ArgumentError
      -> { subject.set_property "_embedded", "lol" }.must_raise ArgumentError
    end

    it "read property" do
      subject.set_property "property", "value"

      subject.property('property').must_equal "value"
    end
  end

  describe "Links" do

    describe "self link" do
      it "no default" do
        subject.links.must_be_empty
        subject.href.must_be_nil
      end

      it "default" do
        resource = Halibut::Core::Resource.new normal_uri

        resource.links.wont_be_empty
        resource.links['self'].first.href.must_equal normal_uri
        resource.href.must_equal normal_uri
      end
    end

    it "adds link to resource" do
      subject.links.must_be_empty

      subject.add_link 'lol', normal_uri
      subject.links['lol'].first.href.must_equal normal_uri
    end

  end

  describe "Namespaces" do
    let(:href) { 'http://relations.com/{rel}' }

    it "has a single namespace" do
      subject.add_namespace 'lol', href

      subject.namespaces.size.must_equal 1
      subject.namespaces.first.must_equal subject.namespace('lol')

      subject.namespace('lol').must_be :templated?
      subject.namespace('lol').href.must_equal href
      subject.namespace('lol').name.must_equal 'lol'
    end

    it "has multiple namespaces" do
      subject.add_namespace 'lol', "http://lol.com/{rel}"
      subject.add_namespace 'lmao', "http://lmao.com/{rel}"

      subject.namespaces.size.must_equal 2

      subject.namespace('lol').must_be :templated?
      subject.namespace('lol').href.must_equal 'http://lol.com/{rel}'
      subject.namespace('lol').name.must_equal 'lol'

      subject.namespace('lmao').must_be :templated?
      subject.namespace('lmao').href.must_equal 'http://lmao.com/{rel}'
      subject.namespace('lmao').name.must_equal 'lmao'
    end
  end

  describe "Embedded resources" do
    subject    { Halibut::Core::Resource.new }
    let(:res1) { Halibut::Core::Resource.new "http://first-resource.com" }
    let(:res2) { Halibut::Core::Resource.new "http://secnd-resource.com" }

    it "no embedded resource" do
      subject.to_hash['_embedded'].must_be_nil
    end

    it "has embedded resource" do
      subject.embed_resource 'user', res1

      subject.to_hash['_embedded']['user'].must_equal res1.to_hash
    end

    it "deprecates calling embed_resource twice for the same relation" do
      subject.embed_resource 'user', res1

      # this call intentionally generates a deprecation warning
      subject.embed_resource 'user', res2

      subject.to_hash['_embedded']['user'].length.must_equal 2
      subject.to_hash['_embedded']['user'].first.must_equal res1.to_hash
      subject.to_hash['_embedded']['user'].last.must_equal res2.to_hash
    end
  end

  describe "Embedded arrays" do
    subject { Halibut::Core::Resource.new }
    let(:res1) { Halibut::Core::Resource.new "http://first-resource.com" }
    let(:res2) { Halibut::Core::Resource.new "http://secnd-resource.com" }

    it "has no embedded arrays" do
      subject.embedded.must_be_empty
    end

    it "has a resource embedded into an array" do
      subject.add_embedded_resource 'users', res1

      subject.to_hash['_embedded']['users'].length.must_equal 1
      subject.to_hash['_embedded']['users'].first.must_equal res1.to_hash
    end

    it "has multiple resources embedded into an array" do
      subject.add_embedded_resource 'users', res1
      subject.add_embedded_resource 'users', res2

      subject.to_hash['_embedded']['users'].length.must_equal 2
      subject.to_hash['_embedded']['users'].first.must_equal res1.to_hash
      subject.to_hash['_embedded']['users'].last.must_equal res2.to_hash
    end
  end

end
