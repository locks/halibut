require_relative 'spec_helper'

describe Halibut::JSON::Parser do
  subject    { Halibut::JSON::Parser }
  let(:json) { load_fixture 'example.json' }
  
  describe "links" do
    let(:links) { JSON.parse(json)['_links'] }
    
    it "parses a single link" do
    end
    
    it "parses multiple links" do
    end
  end
  
end