require_relative 'spec_helper'
require 'json'

describe Halibut do
  describe ".parse_json" do
    describe "(valid_hal_json_str)" do
      it "returns a Resource" do
        Halibut.parse_json("{}").must_be_kind_of Halibut::Core::Resource
      end
    end

    describe "(valid_hal_json_io)" do
      it "returns a Resource" do
        Halibut.parse_json(StringIO.new("{}")).must_be_kind_of Halibut::Core::Resource
      end
    end

    describe "(invalid_json)" do
      it "raises exception" do
        proc { Halibut.parse_json StringIO.new("wat") }.must_raise JSON::ParserError
      end
    end

  end

end
