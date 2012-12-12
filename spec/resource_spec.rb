require_relative 'spec_helper'

describe Halibut::HAL::Resource do
  subject { Halibut::HAL::Resource.new }
  let(:templated_uri) { "http://example.com/{path}{?query}" }
  let(:normal_uri)    { "http://example.com" }

  describe "Properties" do
    it "set property" do
      subject.set_property "property", "value"

      subject.properties['property'].must_equal "value"
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
        resource = Halibut::HAL::Resource.new normal_uri

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
    subject    { Halibut::HAL::Resource.new }
    let(:res1) { Halibut::HAL::Resource.new "http://first-resource.com" }
    let(:res2) { Halibut::HAL::Resource.new "http://secnd-resource.com" }

    it "no embedded resource" do
      subject.embedded.must_be_empty
    end

    it "has embedded resource" do
      subject.embed_resource 'users', res1
      subject.embed_resource 'users', res2

      subject.embedded['users'].first.must_equal res1
      subject.embedded['users'].last.must_equal  res2
    end
  end

  describe "Serialize" do
    subject { Halibut::HAL::Resource.new("http://example.com").to_json }

    it "serializes to JSON" do
      json = load_json "simple"

      MultiJson.load(subject).must_equal MultiJson.load(json)
    end
  end

  describe "Deserialize" do
    subject { Halibut::HAL::Resource.from_json(load_json "serialize") }

    it "deserializes from JSON" do
      order = Halibut::HAL::Resource.new "/orders/123"
      order.set_property "total", 30.00
      order.set_property "currency", "USD"
      order.set_property "status", "shipped"

      resource = Halibut::HAL::Resource.new "/orders"
      resource.add_link "find", "/orders{?id}", templated: true
      resource.add_link "next", "/orders/1", name: 'hotdog'
      resource.add_link "next", "/orders/9"
      resource.set_property "currentlyProcessing", 14
      resource.set_property "shippedToday", 20
      resource.embed_resource "orders", order

      subject.must_equal resource
    end
  end

end
