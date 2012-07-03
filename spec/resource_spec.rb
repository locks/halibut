require_relative 'spec_helper'

describe Halibut::HAL::Resource do
  let(:href) { 'http://example.com/example/1' }
  
  describe "required properties" do
    subject { Halibut::HAL::Resource.new href }
    
    it "must link to itself" do
      subject.url.to_s.must_equal href
    end
    
  end
  
  describe "optional properties" do
  end

end