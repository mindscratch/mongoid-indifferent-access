module Mongoid
  module Extensions
    module Hash
      module IndifferentAccess
        VERSION = "0.0.1"

        def self.included(klass)
          klass.class_eval do
            # @override Mongoid::Field
            def self.field(name, options={})
              field = super(name, options)

              # why oh why does sometimes Hash != Hash? something with my environment maybe?
              # tried ruby 1.9.2-p290 and jruby 1.6.6 (1.9 mode), so we also try checking the class name
              if options[:type] == Hash || options[:type].name =~ /Hash/
                getter_name = name.is_a?(Symbol) ? name : name.intern
                setter_name = "#{getter_name}=".intern

                define_method(getter_name) do
                  val = super()
                  unless val.nil? || val.is_a?(HashWithIndifferentAccess)
                    wrapped_hash = val.with_indifferent_access
                    self.send(setter_name, wrapped_hash)
                    val = wrapped_hash
                  end
                  val
                end

                define_method(setter_name) do |hash|
                  unless hash.nil? || hash.is_a?(HashWithIndifferentAccess)
                    hash = hash.with_indifferent_access
                  end
                  super(hash)
                end
              end
              field
            end
          end
        end
      end
    end
  end
end
