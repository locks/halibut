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

TODO: Write usage instructions here

## RDD

```ruby
# Namespaces
Halibut
Halibut::HAL

Halibut::Document
Halibut::ResourceMap

Halibut::HAL::Link
Halibut::HAL::Resource


hal = Halibut::XML::Builder.new "/api/news" do |it|
    it.attr "some_attribute", "The Value of the Attribute"
    it.attr "another_attribute", "The Value of Another Attribute"

    it.link "search", "/api/news{?search}", :templated => true
    
    it.resource "relation", "/href/etc" do |r|
        r.attr "again", "this"
        r.attr "this",  "again"
        
        r.link "search", "/href/etc?search={term}", :templated => true, :title => "Embedded Resource"
    end
    it.resource "relation", "/href/more" do |r|
        r.attr "again", "this"
        r.attr "this",  "again"
        
        r.link "search", "/href/more?search={term}", :templated => true, :title => "Embedded Resource"
    end
end
hal.to_xml

news = Halibut::HAL::Link.new "index", "/api/news"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
