require_relative 'spec_helper'

describe Halibut::Link do
  
  describe "properties" do
    subject { Halibut::Link.new("http://url.com") }
    
    it "has non-templated link" do
      Halibut::Link.new("http://")
    end
  
  end

end