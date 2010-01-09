require 'show_for/content'
require 'show_for/label'

module ShowFor
  class Builder
    include ShowFor::Content
    include ShowFor::Label

    attr_reader :object, :template

    def initialize(object, template)
      @object, @template = object, template
    end

    def attribute(attribute_name, options={}, &block)
      apply_default_options!(attribute_name, options)
      collection_block, block = block, nil if collection_block?(block)

      value = if block
        block
      elsif @object.respond_to?(:"human_#{attribute_name}")
        @object.send :"human_#{attribute_name}"
      else
        @object.send(attribute_name)
      end

      wrap_label_and_content(attribute_name, value, options, &collection_block)
    end

    def association(association_name, options={}, &block)
      apply_default_options!(association_name, options)
    
      # If a block with an iterator was given, no need to calculate the labels
      # since we want the collection to be yielded. Otherwise, calculate the values.
      value = if collection_block?(block)
        collection_block = block
        @object.send(association_name)
      elsif block
        block
      else
        association = @object.send(association_name)
        values = retrieve_values_from_association(association, options)

        if options.delete(:to_sentence)
          values.to_sentence
        elsif joiner = options.delete(:join)
          values.join(joiner)
        else
          values
        end
      end

      wrap_label_and_content(association_name, value, options, &collection_block)
    end

  protected

    def object_name #:nodoc:
      @object_name ||= @object.class.name.underscore
    end

    def wrap_label_and_content(name, value, options, &block) #:nodoc:
      wrap_with(:wrapper, label(name, options, false) + ShowFor.separator.to_s +
        content(value, options, false, &block), options, true, value.is_a?(Proc))
    end

    # Set "#{object_name}_#{attribute_name}" as in the wrapper tag.
    def apply_default_options!(name, options) #:nodoc:
      html_class = "#{object_name}_#{name}".gsub(/\W/, '')
      wrapper_html = options[:wrapper_html] ||= {}
      wrapper_html[:class] = "#{html_class} #{wrapper_html[:class]}".strip
    end

    # Gets the default tag set in ShowFor module and apply (if defined)
    # around the given content. It also check for html_options in @options
    # hash related to the current type.
    def wrap_with(type, content, options, safe=false, concat=false) #:nodoc:
      tag = options.delete(:"#{type}_tag") || ShowFor.send(:"#{type}_tag")

      html = if tag
        html_options = options.delete(:"#{type}_html") || {}
        html_options[:class] = "#{type} #{html_options[:class]}".strip
        @template.content_tag(tag, content, html_options)
      else
        content
      end

      html.html_safe! if safe && html.respond_to?(:html_safe!)
      concat ? @template.concat(html) : html
    end

    def retrieve_values_from_association(association, options) #:nodoc:
      sample = association.is_a?(Array) ? association.first : association

      if options[:method]
        options[:using] = options.delete(:method)
        ActiveSupport::Deprecation.warn ":method is deprecated. Please use :using instead", caller
      end

      method = options.delete(:using) || ShowFor.association_methods.find { |m| sample.respond_to?(m) }
      association.is_a?(Array) ? association.map(&method) : association.try(method)
    end
  end
end