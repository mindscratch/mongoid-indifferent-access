require 'spec_helper'
require 'mongoid_indifferent_access'
require 'mongoid'

# mocking some of what Mongoid::Document would provide
# so the spec doesn't require having MongoDB running
class MockSuper
  attr_accessor :config
  def self.field(name, options={})
    nil
  end
end

class Guitar < MockSuper
  include Mongoid::Extensions::Hash::IndifferentAccess

  field :config, :type => Hash
end

module Mongoid::Extensions::Hash

  describe IndifferentAccess do
    subject {
      g = Guitar.new
      g.config = {:value => 123}
      g
    }

    it "returns a value given a String as the key" do
      subject.config["value"].should eq(123)
    end

    it "returns a value given a Symbol as the key" do
      subject.config[:value].should eq(123)
    end

    it "returns nil given a non-existing key" do
      subject.config[:non_existant].should be_nil
    end

  end

end