require_relative 'spec_helper'

describe Halibut::HAL::LinkSet do
  let(:href)     { "http://example.com/path"   }
  let(:self_url) { Halibut::HAL::Link.new "self", href }
  let(:document) { Struct.new(:url).new.tap {|it| it.url = self_url } }
  
  describe "initialized with no links" do
    subject { Halibut::HAL::LinkSet.new }
    
    it "is empty when no param" do
      assert_empty subject.links
    end
  end
  
  describe "initialize with one link" do
    subject { Halibut::HAL::LinkSet.new self_url }
    
    it "has one link" do
      subject.links.size.must_equal 1
    end
    
    it "has passed link" do
      subject['self'].must_equal self_url
    end
    
  end
  
end