require 'halibut/hal/resource'

class Halibut::Adapter

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

    def symify(hash)
      hash.each_with_object({}) do |(k,v), obj|
        obj[k.to_sym] = v
      end
    end

    def extract_links(halibut, links)
      return unless links

      links.each do |relation,v|
        link = [] << v
        link = link.flatten

        link.each do |attrs|
          href      = attrs.delete 'href'
          halibut.add_link relation, href, symify(attrs)
        end
      end
    end

    def extract_resources(halibut, resources)
      return unless resources

      resources.each do |relation,value|
        res = [] << value
        res = res.flatten

        res.each do |resource|
          halibut.embed_resource relation, Halibut::Adapter::JSON.load(MultiJson.dump resource)
        end
      end
    end

  end

end