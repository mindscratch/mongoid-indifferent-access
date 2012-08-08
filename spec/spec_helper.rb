require 'rubygems'
require 'bundler/setup'
require 'mongoid_indifferent_access'

Dir['./spec/support/*.rb'].map {|f| require f }

raise "There is no GUITAR!" unless defined?(Guitar)
