require_relative 'spec_helper'

require 'multi_json'
require 'hash'

read_files = ->() {
  Dir.tap {|it| it.chdir('spec/test-resources/src/main/resources') } \
     .glob('*.json') \
     .map {|f| File.read f }
}

describe Halibut do

  it "tests against test-resources" do
    files  = read_files.call

    refilled  = files.map {|f| MultiJson.load f }
    resources = files.map {|f| Halibut::HAL::Resource.from_json f }.map &:to_hash

    zipped = refilled.zip resources
    zipped.each do |json, hal|
      hal.must_equal json
    end
  end

end
