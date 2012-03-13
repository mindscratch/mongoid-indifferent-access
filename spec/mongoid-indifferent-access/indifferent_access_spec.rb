require 'spec_helper'
require 'mongoid_indifferent_access'
require 'mongoid'

class MockSuper
  attr_accessor :config
  def self.field(name, options={})
    nil
  end
end

class Guitar < MockSuper


  # mock Mongoid::Document.field
  def self.field(name, options={})
    nil
  end

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

    it "returns a value for a given key as a String" do
      subject.config["value"].should eq(123)
    end

  end

end