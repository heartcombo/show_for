module ShowFor
  module Content
    def content(value, options={}, apply_options=true, &block)
      if value.blank? && value != false
        value = options.delete(:if_blank) || I18n.t(:'show_for.blank', :default => "Not specified")
        options[:class] = [options[:class], ShowFor.blank_content_class].join(' ')
      end

      # We need to convert value to_a because when dealing with ActiveRecord
      # Array proxies, the follow statement Array# === value return false
      value = value.to_a if value.is_a?(Array)

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
        when NilClass
          ""
        else
          value
      end

      options[:content_html] = options.dup if apply_options
      wrap_with(:content, content, options)
    end

  protected

    def collection_handler(value, options, &block) #:nodoc:
      iterator = collection_block?(block) ? block : ShowFor.default_collection_proc
      response = ""

      value.each do |item|
        response << template.capture(item, &iterator)
      end

      wrap_with(:collection, response.html_safe, options)
    end
  end
end