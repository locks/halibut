require 'halibut/hal/resource'

module Halibut::Adapter

  class JSON
    def initialize(halibut, resource)
      json    = MultiJson.load(resource)

      links     = json.delete '_links'
      resources = json.delete '_embedded'

                    extract_properties halibut, json
      links     and extract_links      halibut, links
      resources and extract_resources  halibut, resources
    end

    def self.load(resource)
      Halibut::HAL::Resource.new.tap {|obj| self.new(obj, resource) }
    end

    def self.dump(resource)
      MultiJson.dump resource.to_hash
    end

    private
    def extract_properties(halibut, json)
      json.each_pair do |k,v|
        halibut.set_property k, v
      end
    end

    def extract_links(halibut, links)
      links.each do |relation,v|
        link = [] << v
        link = link.flatten

        link.each do |attrs|
          href      = attrs.delete 'href'
          halibut.add_link relation, href, attrs
        end
      end if links
    end

    def extract_resources(halibut, resources)
      resources.each do |relation,value|
        res = [] << value
        res = res.flatten

        res.each do |resource|
          halibut.embed_resource relation, Halibut::Adapter::JSON.load(MultiJson.dump resource)
        end
      end if resources
    end

  end

end