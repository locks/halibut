require_relative 'spec_helper'

describe Halibut::Resource do
  let(:templated_uri) { "http://example.com/{path}{?query}" }
  let(:normal_uri)    { "http://example.com" }
  
  describe "Properties" do
    subject { Halibut::Resource.new }
  
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
        resource = Halibut::Resource.new
        resource.links.must_be_empty
      end
      
      it "default" do
        resource = Halibut::Resource.new normal_uri
        
        resource.links.wont_be_empty
        resource.links['self'].must_equal normal_uri
      end
    end
    
  end
  
  describe "Embedded resources" do
    subject { Halibut::Resource.new }
    let(:res1) { Halibut::Resource.new "http://first-resource.com" }
    let(:res2) { Halibut::Resource.new "http://secnd-resource.com" }
    
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
    subject { Halibut::Resource.new("http://example.com").to_json }
    
    it "serializes to JSON" do
      json = load_json "simple"
      
      JSON.load(subject).must_equal JSON.load(json)
    end
  end
end
