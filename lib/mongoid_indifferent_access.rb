module Mongoid
  module Extensions
    module Hash
      module IndifferentAccess

        VERSION = "0.0.5"

        def self.included(klass)
          klass.class_eval do

            def self.field(name, options={})
              field = super(name, options)

              if options[:type] && options[:type].name == 'Hash'
                getter_name = name.to_sym
                setter_name = "#{getter_name}=".to_sym

                hia_define_getter(getter_name, setter_name)
                hia_define_setter(setter_name)

                descendants.each do |subclass|
                  subclass.hia_define_getter(getter_name, setter_name)
                  subclass.hia_define_setter(setter_name)
                end
              end

              field
            end

            def self.hia_define_getter(getter_name, setter_name)
              define_method(getter_name) do
                val = super()
                unless val.nil? || val.is_a?(HashWithIndifferentAccess)
                  wrapped_hash = val.with_indifferent_access
                  self.send(setter_name, wrapped_hash)
                  val = wrapped_hash
                end
                val
              end
            end

            def self.hia_define_setter(setter_name)
              define_method(setter_name) do |hash|
                unless hash.nil? || hash.is_a?(HashWithIndifferentAccess)
                  hash = hash.with_indifferent_access
                end
                super(hash)
              end
            end

          end
        end
      end
    end
  end
end
