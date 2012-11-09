require_relative 'spec_helper'

require 'halibut/link_relation'

describe Halibut::LinkRelation do

  describe "String" do
    it "has a name" do
      relation = Halibut::LinkRelation.new 'default'

      assert relation.name
      relation.name.must_equal 'default'
    end

    it "has a curie and a name" do
      relation = Halibut::LinkRelation.new 'mighty:max'

      relation.curie.wont_be_nil
      relation.curie.must_equal 'mighty'
      relation.name
      relation.name.must_equal 'max'
    end
  end

  describe "Symbol" do
    it "has a name" do
      relation = Halibut::LinkRelation.new :default

      assert relation.name
      relation.name.must_equal 'default'
    end

    it "has a curie and a name" do
      relation = Halibut::LinkRelation.new :'mighty:max'

      relation.curie.wont_be_nil
      relation.curie.must_equal 'mighty'
      relation.name
      relation.name.must_equal 'max'
    end

  end
end