Mongoid Indifferent Access [![Build Status](https://secure.travis-ci.org/mindscratch/mongoid-indifferent-access.png?branch=master)](http://travis-ci.org/mindscratch/mongoid-indifferent-access)
==========================

A Mongoid Hash extension enabling "indifferent access" so you can access keys using Strings or Symbols.

[BSON](http://bsonspec.org/) stores document keys as strings, so Hash keys are strings when going into MongoDB and coming out. This extension allows
a developer to not worry as to whether or not the keys are Strings or Symbols. Instead, by relying on ActiveSupport all Hashes can be
accessed using whichever approach suites the developer.

Ruby/JRuby
----------
Thanks to [travis-ci](http://travis-ci.org) this gem is tested against Ruby 1.9.3 and JRuby 1.6.7.

It should also continue work with Ruby 1.9.2 only if you're using Mongoid 2.4.x. As of Mongoid 3.x, Ruby 1.9.3 or newer is
[required](http://mongoid.org/en/mongoid/docs/tips.html#ruby).

Usage
-----

#### Before

Notice the `nil` values when the Hash values are fetched using Symbols.

````ruby
class QueryResult
  include Mongoid::Document

  field :data, type: Hash
end

# create a QueryResult
QueryResult.create(data: {name: "google", value: 1.32})

# fetch it back from the database
result = QueryResult.first

# check its values
puts result.data["name"]  # => "google"
puts result.data[:value]  # => nil
puts result.data[:name]   # => nil
````

#### After

Notice the values in the Hash can be accessed using Strings or Symbols.

````ruby
class QueryResult
  include Mongoid::Document
  include Mongoid::Extensions::Hash::IndifferentAccess

  field :data, type: Hash
end

# create a QueryResult
QueryResult.create(data: {name: "google", value: 1.32})

# fetch it back from the database
result = QueryResult.first

# check its values
puts result.data["name"]  # => "google"
puts result.data[:value]  # => 1.32
puts result.data[:name]   # => "google"
puts result.data["value"] # => 1.32
````

Contributors
------------

I'd like to give a special shout out to those people who've submitted pull requests (which have been approved and merged):

* [incorvia](https://github.com/incorvia)
  * pulls: [1](https://github.com/mindscratch/mongoid-indifferent-access/pull/1), [2](https://github.com/mindscratch/mongoid-indifferent-access/pull/2)
* [Luke Bergen](https://github.com/lukebergen)
  * pulls: [4](https://github.com/mindscratch/mongoid-indifferent-access/pull/4)
