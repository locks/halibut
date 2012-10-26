require_relative 'spec_helper'

describe Halibut::HAL::Resource do
  let(:templated_uri) { "http://example.com/{path}{?query}" }
  let(:normal_uri)    { "http://example.com" }

  describe "Properties" do
    subject { Halibut::HAL::Resource.new }

    it "set property" do
      subject.set_property "property", "value"

      subject.properties['property'].must_equal "value"
    end

    it "read property" do
      subject.set_property "property", "value"

      subject.get_property('property').must_equal "value"
    end
  end

  describe "Links" do

    describe "self link" do
      it "no default" do
        resource = Halibut::HAL::Resource.new
        resource.links.must_be_empty
      end

      it "default" do
        resource = Halibut::HAL::Resource.new normal_uri

        resource.links.wont_be_empty
        resource.links['self'].first.href.must_equal normal_uri
      end
    end

  end

  describe "Embedded resources" do
    subject { Halibut::HAL::Resource.new }
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
      resource.add_link "find", "/orders{?id}", true
      resource.add_link "next", "/orders/1"
      resource.add_link "next", "/orders/9"
      resource.set_property "currentlyProcessing", 14
      resource.set_property "shippedToday", 20
      resource.embed_resource "orders", order

      subject.must_equal resource
    end
  end
end
