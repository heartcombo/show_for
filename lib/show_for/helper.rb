module ShowFor
  module Helper
    # Creates a div around the object and yields a builder.
    #
    # Example:
    #
    #   show_for @user do |f|
    #     f.attribute :name
    #     f.attribute :email
    #   end
    #
    def show_for(object, html_options={}, &block)
      tag = html_options.delete(:show_for_tag) || ShowFor.show_for_tag

      html_options[:id]  ||= dom_id(object)
      html_options[:class] = "show_for #{dom_class(object)} #{html_options[:class]}".strip
      builder_class = html_options.delete(:builder) || ShowFor::Builder

      content = with_output_buffer do
        yield builder_class.new(object, self)
      end

      content_tag(tag, content, html_options)
    end
  end
end

ActionView::Base.send :include, ShowFor::Helper
