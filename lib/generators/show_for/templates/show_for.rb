# Use this setup block to configure all options available in ShowFor.
ShowFor.setup do |config|
  # The tag which wraps show_for calls.
  # config.show_for_tag = :div

  # The DOM class set for show_for tag. Default is nil
  # config.show_for_class = :custom

  # The tag which wraps each attribute/association call. Default is :p.
  # config.wrapper_tag = :dl

  # The DOM class set for the wrapper tag. Default is :wrapper.
  # config.wrapper_class = :custom

  # The tag used to wrap each label. Default is :strong.
  # config.label_tag = :dt

  # The DOM class of each label tag. Default is :label.
  # config.label_class = :custom

  # The tag used to wrap each content (value). Default is nil.
  # config.content_tag = :dd

  # The DOM class of each content tag. Default is :content.
  # config.content_class = :custom

  # The DOM class set for blank content tags. Default is "blank".
  # config.blank_content_class = 'no_content'

  # Skip blank attributes instead of generating with a default message. Default is false.
  # config.skip_blanks = true

  # The separator between label and content. Default is "<br />".
  # config.separator = "<br />"

  # The tag used to wrap collections. Default is :ul.
  # config.collection_tag = :ul

  # The DOM class set for the collection tag. Default is :collection.
  # config.collection_class = :custom

  # The default iterator to be used when invoking a collection/association.
  # config.default_collection_proc = lambda { |value| "<li>#{ERB::Util.h(value)}</li>".html_safe }

  # The default format to be used in I18n when localizing a Date/Time.
  # config.i18n_format = :default

  # Whenever a association is given, the first method in association_methods
  # in which the association responds to is used to retrieve the association labels.
  # config.association_methods = [ :name, :title, :to_s ]

  # If you want to wrap the text inside a label (e.g. to append a semicolon),
  # specify label_proc - it will be automatically called, passing in the label text.
  # config.label_proc = lambda { |l| l + ":" }
end
