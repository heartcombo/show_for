module ShowFor
  module Content
    def content(value, options={}, apply_options=true, &block)
      content = case value
        when Date, Time, DateTime
          I18n.l value, :format => options.delete(:format) || ShowFor.i18n_format
        when TrueClass
          I18n.t :"show_for.yes", :default => "Yes"
        when FalseClass
          I18n.t :"show_for.no", :default => "No"
        when Array, Hash
          options[:escape] = false
          collection_handler(value, &block)
        when Proc
          options[:escape] = false
          @template.capture(&value)
        when nil, ""
          options[:escape] = false
          options.delete(:if_blank)
        else
          value
      end

      content = @template.send(:h, content) unless options.delete(:escape) == false

      options[:content_html] = options.dup if apply_options
      wrap_with :content, content, options
    end

  protected

    def collection_handler(value, &block) #:nodoc:
      iterator = collection_block?(block) ? block : ShowFor.default_collection_proc
      response = ""

      value.each do |item|
        response << template.capture(item, &iterator)
      end

      wrap_with(:collection, response)
    end

    # Returns true if the block is supposed to iterate through a collection,
    # i.e. it has arity equals to one.
    def collection_block?(block) #:nodoc:
      block && block.arity == 1
    end

    # Returns true if the block deals contains the content.
    def content_block?(block) #:nodoc:
      block && block.arity < 1
    end
  end
end