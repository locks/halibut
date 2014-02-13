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
