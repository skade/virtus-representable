# encoding: utf-8

require 'virtus'
require 'virtus/representable/version'
require 'representable'

require 'active_support/core_ext/module/introspection'

module Virtus
  module Representable
    module ClassMethods
      def represent(virtus_class, opts = {})
        attribute_names = extract_attribute_names(virtus_class, opts)

        attribute_names.each do |name|
          attribute = virtus_class.attribute_set[name]
          handle_collection_attribute(attribute) ||
          handle_embedded_attribute(attribute) ||
          handle_attribute(attribute)
        end
      end

      def handle_collection_attribute(attribute)
        if attribute.class <= Virtus::Attribute::Collection
          collection attribute.name, class: attribute.member_type,
            style => decorator_class(attribute)
        end
      end

      def handle_embedded_attribute(attribute)
        if attribute.class <= Virtus::Attribute::EmbeddedValue
          property attribute.name, style => decorator_class(attribute)
        end
      end

      def handle_attribute(attribute)
        property attribute.name
      end

      def extract_attribute_names(klass, opts = {})
        attribute_names = opts[:only] || klass.attribute_set.map(&:name)
        attribute_names -= Array(opts[:except])
      end

      def class_name(attribute)
        if attribute.class <= Virtus::Attribute::Collection
          attribute.options[:member_type].name
        else
          attribute.options[:primitive].name
        end
      end

      def decorator_class(attribute)
        parent.const_get("#{class_name(attribute)}", false)
      end

      def style
        if self <= ::Representable::Decorator
          :decorator
        else
          :extend
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end