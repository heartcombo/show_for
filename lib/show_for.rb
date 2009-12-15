# ShowFor allows you to quickly show a model information with I18n features.
#
#   <% show_for @admin do |a| %>
#     <%= a.attribute :name %>
#     <%= a.attribute :confirmed? %>
#     <%= a.attribute :created_at, :format => :short %>
#     <%= a.attribute :last_sign_in_at, :if_blank => "Administrator did not access yet"
#                     :wrapper_html => { :id => "sign_in_timestamp" } %>
#
#     <% a.attribute :photo do %>
#       <%= image_url(@admin.photo_url) %>
#     <% end %>
#   <% end %>
#
# Will generate something like:
#
#   <div id="admin_1" class="show_for admin">
#     <p id="admin_name" class="wrapper">
#       <b class="label">Name</b><br />
#       José Valim
#     </p>
#     <p id="admin_confirmed" class="wrapper">
#       <b class="label">Confirmed?</b><br />
#       Yes
#     </p>
#     <p id="admin_created_at" class="wrapper">
#       <b class="label">Created at</b><br />
#       13/12/2009 - 19h17
#     </p>
#     <p id="sign_in_timestamp" class="wrapper">
#       <b class="label">Last sign in at</b><br />
#       Administrator did not access yet
#     </p>
#     <p id="admin_photo" class="wrapper">
#       <b class="label">Photo</b><br />
#       <img src="path/to/photo" />
#     </p>
#   </div>
#
# == Value lookup
#
# To show the proper value, before retrieving the attribute value, show_for
# first looks if a block without argument was given, otherwise checks if a
# :"human_#{attribute}" method is defined and, if not, only then retrieve
# the attribute.
#
# == Options
#
# show_for handles a series of options. Those are:
#
# * :escape * - When the attribute should be escaped. True by default.
#
# * :format * - Sent to I18n.localize when the attribute is a date/time object.
#
# * :if_blank * - An object to be used if the value is blank. Not escaped as well.
#
# Besides, all containers (:label, :content and :wrapper) can have their html
# options configured through the :label_html, :content_html and :wrapper_html
# options. Containers can have their tags configured on demand as well through
# :label_tag, :content_tag and :wrapper_tag options.
#
# == Label
#
# show_for also exposes the label method. In case you want to use the default
# human_attribute_name lookup and the default wrapping:
#
#   a.label :name                     #=> <b class="label">Name</b>
#   a.label "Name", :id => "my_name"  #=> <b class="label" id="my_name">Name</b>
#
# == Associations
#
# show_for also supports associations.
#
#   <% show_for @artwork do |a| %>
#     <%= a.association :artist %>
#     <%= a.association :artist, :method => :name_with_title %>
#
#     <%= a.association :tags %>
#     <%= a.association :tags do
#       @artwork.tags.map(&:name).to_sentence
#     end %>
#
#     <% a.association :fans, :collection_tag => :ul do |fan| %>
#       <li><%= link_to fan.name, fan %></li>
#     <% end %>
#   <% end %>
# 
# The first is a has_one or belongs_to association, which works like an attribute
# to show_for, except it will retrieve the artist association and try to find a
# proper attribute from ShowFor.association_methods to be used. You can pass
# the option :attribute to tell (and not guess) which attribute from the association
# to use.
#
# :tags is a has_and_belongs_to_many association which will return a collection.
# show_for can handle collections by default by wrapping them in list (<ul> with
# each item wrapped by an <li>). However, it also allows you to give a block
# which receives the collection item, as in :fans. In both cases, you can use
# both :collection_tag to set a new tag and :collection_html to customize it.
#
module ShowFor
  mattr_accessor :show_for_tag
  @@show_for_tag = :div

  mattr_accessor :label_tag
  @@label_tag = :b

  mattr_accessor :separator
  @@separator = "<br />"

  mattr_accessor :content_tag
  @@content_tag = nil

  mattr_accessor :wrapper_tag
  @@wrapper_tag = :p

  mattr_accessor :collection_tag
  @@collection_tag = :ul

  mattr_accessor :default_collection_proc
  @@default_collection_proc = lambda { |value| "<li>#{value}</li>" }

  mattr_accessor :i18n_format
  @@i18n_format = :default

  mattr_accessor :association_methods
  @@label_methods = [ :name, :title, :to_s ]

  class Builder
    attr_reader :object, :template

    def initialize(object, template)
      @object, @template = object, template
    end

    def label(text=nil, options=nil)
      @options ||= {}

      label = if text.is_a?(String)
        text
      elsif @options[:label]
        @options.delete(:label)
      else
        human_attribute_name(text || @attribute_name)
      end

      @options[:label_html] = options if options
      wrap_with :label, label
    end

    def attribute(attribute_name, options={}, &block)
      @attribute_name = attribute_name
      @options = options
      @value ||= find_value
      @block = block
      set_default_options!
      wrap_with_label_and_wrapper(content)
    end

    def association(association_name, options={}, &block)
      reflection = find_association_reflection(association_name)
      raise "Association #{association_name.inspect} not found" unless reflection
    
      association = @object.send(association_name)
    
      # If a block with an iterator was given, no need to calculate the labels
      # since we want the collection to be yielded. Otherwise, calculate the values.
      @value = if block_given?
        association if block.arity == 1
      else
        sample = association.is_a?(Array) ? association.first : association
        method = options[:method] || ShowFor.association_methods.find { |m| sample.respond_to?(m) }
        association.is_a?(Array) ? association.map(&attribute) : association.send(attribute)
      end

      returning(attribute(association_name, options, &block)){ @value = nil }
    end

  protected

    def content #:nodoc:
      content = case @value
        when Date, Time, DateTime
          I18n.l @value, :format => @options.delete(:format) || ShowFor.i18n_format
        when TrueClass
          I18n.t :"show_for.yes", :default => "Yes"
        when FalseClass
          I18n.t :"show_for.no", :default => "No"
        when Array
          @options[:escape] = false
          collection_handler
        when Proc
          @options[:escape] = false
          @template.capture(&@value)
        when nil, ""
          @options[:escape] = false
          @options.delete(:if_blank)
        else
          @value
      end

      content = @template.send(:h, content) unless @options.delete(:escape) == false
      wrap_with :content, content
    end

    def collection_handler
      iterator = @block && @block.arity == 1 ? @block : ShowFor.default_collection_proc
      response = ""

      @value.each do |item|
        response << template.capture(item, &iterator)
      end

      wrap_with(:collection, response)
    end

    def object_name #:nodoc:
      @object_name ||= @object.class.name.underscore
    end

    def wrap_with_label_and_wrapper(html) #:nodoc:
      wrap_with(:wrapper, label + ShowFor.separator.to_s + html, true, !!@block)
    end

    def human_attribute_name(attribute) #:nodoc:
      @object.class.human_attribute_name(attribute.to_s)
    end

    # Method which actually does the value lookup.
    def find_value #:nodoc:
      if @block && @block.arity < 1
        @block
      elsif @object.respond_to?(:"human_#{@attribute_name}")
        @object.send :"human_#{@attribute_name}"
      else
        @object.send(@attribute_name)
      end
    end

    # Set the "#{object_name}_#{attribute_name}" as id in the wrapper tag.
    def set_default_options! #:nodoc:
      @options[:wrapper_html] ||= {}
      @options[:wrapper_html][:id] ||= "#{object_name}_#{@attribute_name}".gsub(/\W/, '')
    end

    # Gets the default tag set in ShowFor module and apply (if defined)
    # around the given content. It also check for html_options in @options
    # hash related to the current type.
    def wrap_with(type, content, safe=false, concat=false) #:nodoc:
      tag = @options.delete(:"#{type}_tag") || ShowFor.send(:"#{type}_tag")

      html = if tag
        html_options = @options.delete(:"#{type}_html") || {}
        html_options[:class] = "#{type} #{html_options[:class]}".strip
        @template.content_tag(tag, content, html_options)
      else
        content
      end

      html.html_safe! if safe && html.respond_to?(:html_safe!)
      concat ? @template.concat(html) : html
    end

    # Find association related to attribute
    def find_association_reflection(association) #:nodoc:
      @object.class.reflect_on_association(association) if @object.class.respond_to?(:reflect_on_association)
    end
  end
end