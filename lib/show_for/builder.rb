require 'show_for/attribute'
require 'show_for/association'
require 'show_for/content'
require 'show_for/label'

module ShowFor
  class Builder
    include ShowFor::Attribute
    include ShowFor::Association
    include ShowFor::Content
    include ShowFor::Label

    attr_reader :object, :template

    def initialize(object, template)
      @object, @template = object, template
    end

  protected

    def object_name #:nodoc:
      @object_name ||= begin
                         model_name = @object.class.model_name

                         # TODO Remove this check when we drop support to Rails 3.0
                         if model_name.respond_to?(:param_key)
                           model_name.param_key
                         else
                           model_name.singular
                         end
                       end
    end

    def wrap_label_and_content(name, value, options, &block) #:nodoc:
      unless skip?(value)
        label = label(name, options, false)
        label += ShowFor.separator.to_s.html_safe if label.present?
        wrap_with(:wrapper, label + content(value, options, false, &block), apply_wrapper_options!(:wrapper, options, value))
      end
    end

    def wrap_content(name, value, options, &block) #:nodoc:
      wrap_with(:wrapper, content(value, options, false, &block), apply_wrapper_options!(:wrapper, options, value))
    end

    # Set "#{object_name}_#{attribute_name}" as in the wrapper tag.
    def apply_default_options!(name, options) #:nodoc:
      html_class = "#{object_name}_#{name}".gsub(/\W/, '')
      wrapper_html = options[:wrapper_html] ||= {}
      wrapper_html[:class] = "#{html_class} #{wrapper_html[:class]}".rstrip
    end

    def apply_wrapper_options!(type, options, value)
      options[:"#{type}_html"] ||= {}
      options[:"#{type}_html"][:class] = [options[:"#{type}_html"][:class], ShowFor.blank_content_class].join(' ') if value.blank? && value != false
      options
    end

    # Gets the default tag set in ShowFor module and apply (if defined)
    # around the given content. It also check for html_options in @options
    # hash related to the current type.
    def wrap_with(type, content, options) #:nodoc:
      unless skip?(content)
        tag = options.delete(:"#{type}_tag") || ShowFor.send(:"#{type}_tag")

        if tag
          type_class = ShowFor.send :"#{type}_class"
          html_options = options.delete(:"#{type}_html") || {}
          html_options[:class] = "#{type_class} #{html_options[:class]}".rstrip
          @template.content_tag(tag, content, html_options)
        else
          content
        end
      end
    end

    # Returns true if the block is supposed to iterate through a collection,
    # i.e. it has arity equals to one.
    def collection_block?(block) #:nodoc:
      block && block.arity == 1
    end

    # return true if the value is blank and show_for is configured to skip
    # blank values.
    def skip?(value) #:nodoc:
      !!(value.blank? && value != false && ShowFor.skip_blanks)
    end
  end
end

