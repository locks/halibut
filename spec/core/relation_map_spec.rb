require_relative '../spec_helper'

require 'halibut/core/relation_map'

describe Halibut::Core::RelationMap do
  subject { Halibut::Core::RelationMap.new }

  it "is empty" do
    subject.must_be_empty
  end

  it "has a single item per relation" do
    subject.add 'first' , 'first'
    subject.add 'second', 'second'

    subject['first'].first.must_equal  'first'
    subject['second'].last.must_equal  'second'

  end

  it "has various items per relation" do
    subject.add 'first', 'first'
    subject.add 'first', 'second'

    subject['first'].length.must_equal  2
    subject['first'].first.must_equal 'first'
    subject['first'].last.must_equal  'second'
  end

end