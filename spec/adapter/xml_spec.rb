require_relative '../spec_helper'


read_files = ->() {
  Dir.tap {|it| it.chdir('spec/test-resources/src/main/resources') } \
     .glob('*.xml') \
     .map {|f| File.read f }
}


describe Halibut::Adapter::XML do

  it "serializes to XML" do
    skip "To Be Implemented"
  end

  it "deserializes from XML" do
    # skip "Test is failing god knows why."
    builder = Halibut::Builder.new 'https://example.com/api/customer/123456' do
      property 'age', "33"
      property 'expired', "false"
      property 'id', "123456"
      property 'name', 'Example Resource'
      property 'nullprop', ""
      property 'optional', "true"

      relation 'curie' do
        link 'https://example.com/apidocs/accounts', name: 'ns'
        link 'https://example.com/apidocs/roles',    name: 'role'
      end
      link 'ns:parent', 'https://example.com/api/customer/1234', name: 'bob',
                                                                 title: 'The Parent',
                                                                 hreflang: 'en'
      link 'ns:users', 'https://example.com/api/customer/123456?users'
    end.resource

    xml = load_resource('exampleWithNullProperty.xml')

    deserialized = Halibut::Adapter::XML.load(xml)
    deserialized.must_equal builder, diff(deserialized.to_hash, builder.to_hash)
  end

  it "provides to_xml helper" do
    skip "To Be Implemented"

    xml = Halibut::Adapter::XML.load(load_resource 'exampleWithNullProperty.xml')
    xml = Halibut::Adapter::XML.dump(xml)
  end

end