module ShowFor
  module Content
    def content(value, options={}, apply_options=true, &block)
      value = options.delete(:if_blank) || ShowFor.blank_content if value.blank? && value != false
      options[:class] = [options[:class], ShowFor.blank_content_class].join(' ') if value.blank?

      content = case value
        when Date, Time, DateTime
          I18n.l value, :format => options.delete(:format) || ShowFor.i18n_format
        when TrueClass
          I18n.t :"show_for.yes", :default => "Yes"
        when FalseClass
          I18n.t :"show_for.no", :default => "No"
        when Array, Hash
          options[:escape] = false
          collection_handler(value, options, &block)
        when Proc
          options[:escape] = false
          @template.capture(&value)
        when NilClass
          ""
        else
          value
      end

      content = @template.send(:h, content) unless options.delete(:escape) == false
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

      wrap_with(:collection, response, options)
    end

    # Returns true if the block is supposed to iterate through a collection,
    # i.e. it has arity equals to one.
    def collection_block?(block) #:nodoc:
      block && block.arity == 1
    end
  end
end