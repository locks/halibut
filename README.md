# Halibut [![endorse](http://api.coderwall.com/locks/endorsecount.png)](http://coderwall.com/locks)

[![Gem Version](https://badge.fury.io/rb/halibut.png)](http://badge.fury.io/rb/halibut)
[![Build Status](https://secure.travis-ci.org/locks/halibut.png?branch=master)](https://travis-ci.org/locks/halibut)
[![Dependency Status](https://gemnasium.com/locks/halibut.png)](https://gemnasium.com/locks/halibut)
[![Code Climate](https://codeclimate.com/github/locks/halibut.png)](https://codeclimate.com/github/locks/halibut)

Halibut is a tiny gem that makes it easier to deal with the [HAL](http://stateless.co/hal_specification.html) format.

In providing tools to build, (de)serialize, and manipulate HAL resources,
Halibut has the following goals:

- Provide Ruby abstractions
- Clean, small API
- Easily composable, for use in other libraries

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

builder = Halibut::Builder.new '/orders' do
    property 'currentlyProcessing', 14
    property 'shippedToday', 20
    
    namespace 'th', 'http://things-db.com/{rel}'
    
    link 'find', '/orders{?id}', templated: true
    link 'next', '/orders/1', name: 'hotdog'
    link 'next', '/orders/9'
    
    link 'th:manufacturer', '/manufacturer/1'
    link 'th:manufacturer', '/manufacturer/2'
    link 'th:manufacturer', '/manufacturer/3'
end

# alternatively

builder = Halibut::Builder.new '/orders' do
    property 'currentlyProcessing', 14
    property 'shippedToday', 20
    
    namespace 'th', 'http://things-db.com/{rel}'
    
    link 'find', '/orderes{?id}', templated: true
    relation 'next' do
        link '/orders/1', name: 'hotdog'
        link '/orders/9'
    end
    relation 'th:manufacturer' do
        link '/manufacturers/1'
        link '/manufacturers/2'
        link '/manufacturers/3'
    end
end

resource = builder.resource
```

### JSON
```ruby
require 'halibut/adapter/json'

# converting to JSON
Halibut::Adapter::JSON.dump resource

# creating a resource from JSON
resource = Halibut::Adapter::JSON.load 'resource.json'
```

### XML
```ruby
require 'halibut/adapter/xml'

# converting to XML
# Coming soon…

# creating a resource from XML
resource = Halibut::Adapter::XML.load 'resource.xml'
```

## Contributing

1. Fork it
    1. `git submodule update --init`
    2. `bundle install`, optionally pass `--without-development` and use your
       own tools
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
