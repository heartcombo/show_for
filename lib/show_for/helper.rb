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
      html_options[:class] = show_for_html_class(object, html_options)

      builder = html_options.delete(:builder) || ShowFor::Builder
      content = capture(builder.new(object, self), &block)

      content_tag(tag, content, html_options)
    end

    private

    def show_for_html_class(object, html_options)
      "show_for #{dom_class(object)} #{html_options[:class]} #{ShowFor.show_for_class}".squeeze(" ").rstrip
    end
  end
end

ActionView::Base.send :include, ShowFor::Helper
