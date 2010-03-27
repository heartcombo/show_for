require 'show_for/helper'

module ShowFor
  autoload :Builder, 'show_for/builder'

  mattr_accessor :show_for_tag
  @@show_for_tag = :div

  mattr_accessor :label_tag
  @@label_tag = :strong

  mattr_accessor :separator
  @@separator = "<br />"

  mattr_accessor :content_tag
  @@content_tag = nil

  mattr_accessor :blank_content_class
  @@blank_content_class = "blank"

  mattr_accessor :blank_content
  @@blank_content = ""

  mattr_accessor :wrapper_tag
  @@wrapper_tag = :p

  mattr_accessor :collection_tag
  @@collection_tag = :ul

  mattr_accessor :default_collection_proc
  @@default_collection_proc = lambda { |value| "<li>#{value}</li>" }

  mattr_accessor :i18n_format
  @@i18n_format = :default

  mattr_accessor :association_methods
  @@association_methods = [ :name, :title, :to_s ]
  
  mattr_accessor :label_proc
  @@label_proc = nil

  # Yield self for configuration block:
  #
  #   ShowFor.setup do |config|
  #     config.i18n_format = :long
  #   end
  #
  def self.setup
    yield self
  end
end