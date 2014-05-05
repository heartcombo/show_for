module ShowFor
  module Content
    def content(value, options={}, apply_options=true, &block)
      # cache value for apply_wrapper_options!
      sample_value = value

      # We need to convert value to_a because when dealing with ActiveRecord
      # Array proxies, the follow statement Array# === value return false
      value = value.to_a if value.respond_to?(:to_ary)

      content = case value
        when Date, Time, DateTime
          I18n.l value, :format => options.delete(:format) || ShowFor.i18n_format
        when TrueClass
          I18n.t :"show_for.yes", :default => "Yes"
        when FalseClass
          I18n.t :"show_for.no", :default => "No"
        when Array, Hash
          collection_handler(value, options, &block)
        when Proc
          @template.capture(&value)
        when Numeric
          value.to_s
        else
          if value.blank?
            blank_value(options)
          elsif block
            template.capture(value, &block)
          else
            value
          end
      end

      if content.blank?
        content = blank_value(options)
      end

      options[:content_html] = options.except(:content_tag) if apply_options
      wrap_with(:content, content, apply_wrapper_options!(:content, options, sample_value) )
    end

  protected

    def collection_handler(value, options, &block) #:nodoc:
      return blank_value(options) if value.blank?

      iterator = collection_block?(block) ? block : ShowFor.default_collection_proc

      response = value.map do |item|
        template.capture(item, &iterator)
      end.join.html_safe

      wrap_with(:collection, response, options)
    end

    def translate_blank_html
      template.t(:'show_for.blank_html', :default => translate_blank_text)
    end

    def translate_blank_text
      I18n.t(:'show_for.blank', :default => "Not specified")
    end

    def blank_value(options)
      options.delete(:if_blank) || translate_blank_html
    end
  end
end
