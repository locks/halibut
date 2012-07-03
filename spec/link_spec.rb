require_relative 'spec_helper'

describe Halibut::HAL::Link do
  let(:rel)  { :self }
  let(:href) { 'http://cyberscore.dev/api/users' }
  let(:options) do
    { "templated" => true,
      "title"     => "Sample title",
      "hreflang"  => "en-us" }
  end

  describe "required properties" do
    subject { Halibut::HAL::Link.new rel, href }
    
    it "must have a self link" do
      subject.href.must_equal URI.parse(href)
    end
  end
  
  describe "optional properties" do
    subject { Halibut::HAL::Link.new rel, href, options }
    
    describe "templated" do
      
      it "should be true if href is a URI Template" do        
        subject.templated?.must_equal true
      end
      
      it "should be false if href is not a URI Template" do
        link = Halibut::HAL::Link.new rel, href
        link.templated?.must_equal false
      end
      
    end
    
    it "has a title" do
      subject.title.must_equal options["title"]
    end
    
    it "has an hreflang" do
      subject.hreflang.must_equal options["hreflang"]
    end
    
  end
  
end