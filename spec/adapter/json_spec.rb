require_relative '../spec_helper'

require 'halibut/adapter/json'

describe Halibut::Adapter::JSON do

  it "serializes to JSON" do
    resource = Halibut::HAL::Resource.new("http://example.com")
    subject  = Halibut::Adapter::JSON.dump resource
    json     = load_json "simple"

    MultiJson.load(subject).must_equal MultiJson.load(json)
  end

  it "deserializes from JSON" do
    subject = Halibut::Adapter::JSON.load(load_json "serialize")

    order = Halibut::HAL::Resource.new "/orders/123"
    order.set_property "total", 30.00
    order.set_property "currency", "USD"
    order.set_property "status", "shipped"

    resource = Halibut::HAL::Resource.new "/orders"
    resource.add_link "find", "/orders{?id}", templated: true
    resource.add_link "next", "/orders/1", "name" => 'hotdog'
    resource.add_link "next", "/orders/9"
    resource.set_property "currentlyProcessing", 14
    resource.set_property "shippedToday", 20
    resource.embed_resource "orders", order

    subject.must_equal resource
  end

end