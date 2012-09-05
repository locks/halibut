require_relative 'spec_helper'

describe Halibut::Resource do
  let(:templated_uri) { "http://example.com/{path}{?query}" }
  let(:normal_uri)    { "http://example.com" }
  
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
    
    describe "link relation" do
      subject { Halibut::Resource.new }
      
      it "single link per relation" do
        subject.add_link "random", normal_uri
        
        subject.links.wont_be_empty
        subject.links['random'].must_equal normal_uri
      end
      
      it "multiple link per relation" do
        subject.add_link "random", normal_uri
        subject.add_link "random", templated_uri
        
        subject.links['random'].size.must_equal 2
        subject.links['random'].first.must_equal normal_uri
        subject.links['random'].last.must_equal  templated_uri
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
    
    it "one embedded resource per relation" do
      subject.embed_resource "random", res1
      
      subject.embedded['random'].must_equal res1
    end
    
    it "several embedded resources per relation" do
      subject.embed_resource("random", res1)
      subject.embed_resource("random", res2)
      
      subject.embedded['random'].size.must_equal 2
      subject.embedded['random'].first.must_equal res1
      subject.embedded['random'].last.must_equal  res2
    end
  end

end
