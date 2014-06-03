require_relative '../spec_helper'

require 'halibut/core/relation_map'

describe Halibut::Core::RelationMap do
  subject { Halibut::Core::RelationMap.new }

  it "is empty" do
    subject.must_be_empty
  end

  describe '#add' do
    it "has a single item per relation" do
      subject.add 'first' , { value: 'first' }
      subject.add 'second', { value: 'second' }

      subject['first'].first[:value].must_equal 'first'
      subject['second'].last[:value].must_equal 'second'

    end

    it "has various items per relation" do
      subject.add 'first', { value: 'first' }
      subject.add 'first', { value: 'second' }

      subject['first'].length.must_equal  2
      subject['first'].first[:value].must_equal 'first'
      subject['first'].last[:value].must_equal  'second'
    end

    # todo: throw an exception if add receives a value that does not respond to to_hash
    it 'throws an exception if item does not respond to #to_hash' do
      assert_raises(ArgumentError) do
        subject.add 'first', 'not-hashable'
      end
    end
  end

  describe '#to_hash' do
    describe 'when single item arrays become objects' do
      it 'generates single item relations correctly' do
        subject.add('person', { name: 'bob' })

        subject.to_hash['person'][:name].must_equal 'bob'
      end

      it 'generates multi item relations correctly' do
        subject.add('person', { name: 'bob' })
        subject.add('person', { name: 'floyd' })

        hashed_people = subject.to_hash['person']
        hashed_people.length.must_equal 2
        hashed_people[0][:name].must_equal 'bob'
        hashed_people[1][:name].must_equal 'floyd'
      end
    end

    describe 'when single item arrays stay arrays' do
      subject { Halibut::Core::RelationMap.new(single_item_arrays: true) }

      it 'generates single item relations correctly' do
        subject.add('person', { name: 'bob' })

        hashed_people = subject.to_hash['person']
        hashed_people.length.must_equal 1
        hashed_people[0][:name].must_equal 'bob'
      end

      it 'generates multi item relations correctly' do
        subject.add('person', { name: 'bob' })
        subject.add('person', { name: 'floyd' })

        hashed_people = subject.to_hash['person']
        hashed_people.length.must_equal 2
        hashed_people[0][:name].must_equal 'bob'
        hashed_people[1][:name].must_equal 'floyd'
      end
    end
  end
end
