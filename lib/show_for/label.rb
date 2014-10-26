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

      return ''.html_safe if label == false

      label_wrapper = options.try(:delete, :l_wrapper_tags)
      options[:label_html] = options.dup if apply_options

      label = ShowFor.label_proc.call(label) if options.fetch(:wrap_label, true) && ShowFor.label_proc
      
      
      label = wrap_with :label, label, options
      
      if label_wrapper
        if !label_wrapper.respond_to? :each  
          label_wrapper = [label_wrapper]
        end
        label_wrapper.each do |option|
          puts 'entered'
          label = wrap_with :l_wrapper, label, { l_wrapper_tag: option }
        end
      end
      label
    end

    protected

    def human_attribute_name(attribute) #:nodoc:
      @object.class.human_attribute_name(attribute.to_s)
    end
  end
end
