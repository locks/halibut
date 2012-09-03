require_relative 'spec_helper'

describe Halibut::Link do
  let(:regular_url)   { "http://example.com" }
  let(:templated_url) { "hhtp://example.com/{id}" }
  
  it "accepts non-templated href" do
    link = Halibut::Link.new(regular_url)
    
    link.href.must_equal regular_url
    link.templated?.must_equal false
  end
  
  it "accepts templated href" do
    link =  Halibut::Link.new(templated_url, true)
    
    link.href.must_equal templated_url
    link.templated?.must_equal true
  end
  
end