module Mongoid::Extensions::Hash::IndifferentAccess
  VERSION = "0.0.1"

  def self.included(klass)
    puts "included"
    klass.class_eval do
      puts "eval class"
      # @override Mongoid::Field
      def self.field(name, options={})
        puts "defining field: #{name}"
        field = super(name, options)
        puts "Field: #{field}"
        puts "\t#{field.inspect}"

        field_type = options.fetch(:type, nil)
        puts "Field type: #{field_type}, #{field_type == Hash}, #{field_type.class}"
        if field_type.name == Hash.name
          getter_name = name.is_a?(Symbol) ? name : name.intern
          setter_name = "#{getter_name}=".intern
          puts "Getter: #{getter_name}, Setter: #{setter_name}"

          define_method(getter_name) do
            puts "getting value 2"
            val = super()
            puts "\tgot val"
            unless val.nil? || val.is_a?(HashWithIndifferentAccess)
              wrapped_hash = val.with_indifferent_access
              self.send(setter_name, wrapped_hash)
              val = wrapped_hash
            end
            val
          end

          define_method(setter_name) do |hash|
            puts "setting value"
            unless hash.nil? || hash.is_a?(HashWithIndifferentAccess)
              hash = hash.with_indifferent_access
            end
            super(hash)
          end
        else
          puts "not a hash, #{options[:type] == Hash}"
        end
        field
      end
    end
  end
end
