require_relative 'spec_helper'

require 'multi_json'

read_files = ->() {
  Dir.tap {|it| it.chdir('spec/test-resources/src/main/resources') } \
     .glob('*.json') \
     .map {|f| File.read f }
}

describe Halibut do

  it "tests against test-resources" do
    skip "Heh"
    files  = read_files.call

    refilled  = files.map {|f| MultiJson.load f }
    resources = files.map {|f| Halibut::Adapter::JSON.load f }.map &:to_hash

    zipped = refilled.zip resources
    zipped.each do |json, hal|
      hal.must_equal json
    end
  end

end
