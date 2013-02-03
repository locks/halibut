require_relative '../spec_helper'

require 'halibut/core/link'

describe Halibut::Core::Link do
  let(:normal_uri) { 'http://example.com'      }
  let(:tmpl_uri)   { 'http://example.com/{id}' }

  describe "href" do
    it "accepts non-templated uri" do
      link = Halibut::Core::Link.new normal_uri

      link.templated?.must_equal false
      link.href.must_equal normal_uri
    end

    it "accepts templated uri" do
      link = Halibut::Core::Link.new tmpl_uri, templated: true

      link.templated?.must_equal true
      link.href.must_equal tmpl_uri
    end
  end

  describe "optionals" do
    it "are set correctly" do
      link1 = Halibut::Core::Link.new normal_uri, {
        :type     => 'type',
        :name     => 'name',
        :profile  => 'profile',
        :title    => 'title',
        :hreflang => 'hreflang'
      }
      link2 = Halibut::Core::Link.new normal_uri, {
        :type     => 'type',
        :name     => 'name',
        :profile  => 'profile',
        :title    => 'title',
        :hreflang => 'hreflang'
      }

      link1.type.must_equal     "type"
      link1.name.must_equal     "name"
      link1.profile.must_equal  "profile"
      link1.title.must_equal    "title"
      link1.hreflang.must_equal "hreflang"

      link2.type.must_equal     "type"
      link2.name.must_equal     "name"
      link2.profile.must_equal  "profile"
      link2.title.must_equal    "title"
      link2.hreflang.must_equal "hreflang"

      link1.must_equal link2
    end
  end
end