require 'spec_helper'

describe Halibut::Link do

  describe "href" do
    let(:normal_uri) { 'http://example.com'      }
    let(:tmpl_uri)   { 'http://example.com/{id}' }
    
    it "accepts non-templated uri" do
      link = Halibut::Link.new normal_uri
      
      link.templated?.must_equal false
      link.href.must_equal normal_uri
    end
    
    it "accepts templated uri" do
      link = Halibut::Link.new tmpl_uri, true
      
      link.templated?.must_equal true
      link.href.must_equal tmpl_uri
    end
    
  end

end