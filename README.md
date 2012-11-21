# Halibut

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'halibut'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install halibut

## Usage

There are three ways to get a resource with halibut: manual, Builder, and JSON.

### Manual

```ruby
require 'halibut'

# manually creating a resource
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
```

### Halibut::Builder
```ruby
require 'halibut/builder'

Halibut::Builder.new '/orders' do
    property 'currentlyProcessing', 14
    property 'shippedToday', 20
    
    link 'find', '/orders{?id}', templated: true
    link 'next', '/orders/1', name: 'hotdog'
    link 'next', '/orders/9'
end
```

### JSON
```ruby
require 'halibut/adapter/json'

# converting to JSON
Halibut::Adapter::JSON.dump resource

# creating a resource from JSON
resource = Halibut::Adapter::JSON.load 'resource.json'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
