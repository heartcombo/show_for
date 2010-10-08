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

      return nil.to_s if label == false
      options[:label_html] = options.dup if apply_options
      wrap_with :label, label, options
    end

  protected

    def human_attribute_name(attribute) #:nodoc:
      @object.class.human_attribute_name(attribute.to_s)
    end
  end
end
