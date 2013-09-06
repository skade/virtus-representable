require 'representable'
require 'active_support/core_ext/module/introspection'

module Virtus
  module Representable
    module Decorator
      module ClassMethods
        def represent(virtus_class, opts = {})
          if opts[:only]
            attribute_names = opts[:only]
          else
            attribute_names = virtus_class.attribute_set.map(&:name)
          end

          if opts[:except]
            attribute_names -= opts[:except]
          end

          attribute_names.each do |name|
            attribute = virtus_class.attribute_set[name]
            if attribute.class <= Virtus::Attribute::Collection
              collection attribute.name, :class => attribute.member_type,
                :decorator => decorator_class(attribute)
            elsif attribute.class <= Virtus::Attribute::EmbeddedValue
              property attribute.name, :decorator => decorator_class(attribute)
            else
              property attribute.name
            end
          end
        end

        def class_name(attribute)
          if attribute.class <= Virtus::Attribute::Collection
            attribute.options[:member_type].name
          else
            attribute.options[:primitive].name
          end
        end

        def decorator_class(attribute)
          parent.const_get("#{class_name(attribute)}")
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end