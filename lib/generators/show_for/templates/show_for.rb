# Use this setup block to configure all options available in ShowFor.
ShowFor.setup do |config|
  # The tag which wraps show_for calls.
  # config.show_for_tag = :div

  # The tag which wraps each attribute/association call. Default is :p.
  # config.wrapper_tag = :dl

  # The tag used to wrap each label. Default is :strong.
  # config.label_tag = :dt

  # The tag used to wrap each content (value). Default is nil.
  # config.content_tag = :dd

  # The DOM class set for blank content tags. Default is "blank".
  # config.blank_content_class = 'no_content'

  # The separator between label and content. Default is "<br />".
  # config.separator = "<br />"

  # The tag used to wrap collections. Default is :ul.
  # config.collection_tag = :ul

  # The default iterator to be used when invoking a collection/association.
  # config.default_collection_proc = lambda { |value| "<li>#{value}</li>" }

  # The default format to be used in I18n when localizing a Date/Time.
  # config.i18n_format = :default

  # Whenever a association is given, the first method in association_methods
  # in which the association responds to is used to retrieve the association labels.
  # config.association_methods = [ :name, :title, :to_s ]

  # If you want to wrap the text inside a label (e.g. to append a semicolon),
  # specify label_proc - it will be automatically called, passing in the label text.
  # config.label_proc = lambda { |l| l + ":" }
end
