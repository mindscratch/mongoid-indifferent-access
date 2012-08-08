require 'spec_helper'

class Guitar
  include Mongoid::Document
  include Mongoid::Extensions::Hash::IndifferentAccess

  field :config, :type => Hash
end

class Mandalin < Guitar
end

module Mongoid::Extensions::Hash

  describe IndifferentAccess do

    before :each do
      @subject = Guitar.new
      @subject.config = {:value => 123}
    end

    it "returns a value given a String as the key" do
      @subject.config["value"].should eq(123)
    end

    it "returns a value given a Symbol as the key" do
      @subject.config[:value].should eq(123)
    end

    it "returns nil given a non-existing key" do
      @subject.config[:non_existant].should be_nil
    end

    describe 'subclasses' do

      before :each do
        @sub_subject = Mandalin.new
        @sub_subject.config = {:value => 123}
      end

      it "returns a value given a String as the key" do
        @sub_subject.config["value"].should eq(123)
      end

      it "returns a value given a Symbol as the key" do
        @sub_subject.config[:value].should eq(123)
      end

      it "returns nil given a non-existing key" do
        @sub_subject.config[:non_existant].should be_nil
      end

      describe 'reload superclass' do

        before :each do
          load 'support/guitar.rb'
          @sub_subject = Mandalin.new
          @sub_subject.config = {:value => 123}
        end

        it "returns a value given a String as the key" do
          @sub_subject.config["value"].should eq(123)
        end

        it "returns a value given a Symbol as the key" do
          @sub_subject.config[:value].should eq(123)
        end

        it "returns nil given a non-existing key" do
          @sub_subject.config[:non_existant].should be_nil
        end

      end

    end

  end

end
