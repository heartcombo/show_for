module ShowFor
  module Label
    def label(text_or_attribute, options={}, apply_options=true)
      label = if text_or_attribute.is_a?(String)
        text_or_attribute
      elsif options.key?(:label)
        options.delete(:label)
      else
        human_attribute_name(text_or_attribute)
      end

      return "" if label == false
      options[:label_html] = options.dup if apply_options
      label = ::I18n.t(:'show_for.label_wrapper', :label => label, :default => "{{label}}")
      wrap_with :label, label, options
    end

  protected

    def human_attribute_name(attribute) #:nodoc:
      @object.class.human_attribute_name(attribute.to_s)
    end
  end
end