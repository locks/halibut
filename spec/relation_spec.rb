require_relative 'spec_helper'

describe Halibut::Relation do

  it "has a name" do
    relation = Halibut::Relation.new 'default'

    assert relation.name
    relation.name.must_equal 'default'
  end

  it "has a curie and a name" do
    relation = Halibut::Relation.new 'mighty:max'

    relation.curie.wont_be_nil
    relation.curie.must_equal 'mighty'
    relation.name
    relation.name.must_equal 'max'
  end

end