# ShowFor

[![Gem Version](https://fury-badge.herokuapp.com/rb/show_for.png)](http://badge.fury.io/rb/show_for)
[![Code Climate](https://codeclimate.com/github/heartcombo/show_for.png)](https://codeclimate.com/github/heartcombo/show_for)

ShowFor allows you to quickly show a model information with I18n features.

```erb
<%= show_for @user do |u| %>
  <%= u.attribute :name %>
  <%= u.attribute :nickname, in: :profile %>
  <%= u.attribute :confirmed? %>
  <%= u.attribute :created_at, format: :short %>
  <%= u.attribute :last_sign_in_at, if_blank: "User did not access yet",
                  wrapper_html: { id: "sign_in_timestamp" } %>

  <%= u.attribute :photo do %>
    <%= image_tag(@user.photo_url) %>
  <% end %>

  <%= u.association :company %>
  <%= u.association :tags, to_sentence: true %>
<% end %>
```

## Installation

Install the gem:

    gem install show_for

Or add ShowFor to your Gemfile and bundle it up:

    gem 'show_for'

Run the generator:

    rails generate show_for:install

And you are ready to go.

Note: This branch aims Rails 5 and 6 support, so if you want to use it with
older versions of Rails, check out the available branches.

## Usage

ShowFor allows you to quickly show a model information with I18n features.

```erb
<%= show_for @admin do |a| %>
  <%= a.attribute :name %>
  <%= a.attribute :login, value: :upcase %>
  <%= a.attribute :confirmed? %>
  <%= a.attribute :created_at, format: :short %>
  <%= a.attribute :last_sign_in_at, if_blank: "Administrator did not access yet"
                  wrapper_html: { id: "sign_in_timestamp" } %>

  <%= a.attribute :photo do %>
    <%= image_tag(@admin.photo_url) %>
  <% end %>

  <% a.value :biography %>
<% end %>
```

Will generate something like:

```html
<div id="admin_1" class="show_for admin">
  <div class="wrapper admin_name">
    <strong class="label">Name</strong><br />
    José Valim
  </div>
  <div class="wrapper admin_login">
    <strong class="label">Login</strong><br />
    JVALIM
  </div>
  <div class="wrapper admin_confirmed">
    <strong class="label">Confirmed?</strong><br />
    Yes
  </div>
  <div class="wrapper admin_created_at">
    <strong class="label">Created at</strong><br />
    13/12/2009 - 19h17
  </div>
  <div id="sign_in_timestamp" class="wrapper admin_last_sign_in_at">
    <strong class="label">Last sign in at</strong><br />
    Administrator did not access yet
  </div>
  <div class="wrapper admin_photo">
    <strong class="label">Photo</strong><br />
    <img src="path/to/photo" />
  </div>
  <div class="wrapper admin_biography">
    Etiam porttitor eros ut diam vestibulum et blandit lectus tempor. Donec
    venenatis fermentum nunc ac dignissim. Pellentesque volutpat eros quis enim
    mollis bibendum. Ut cursus sem ac sem accumsan nec porttitor felis luctus.
    Sed purus nunc, auctor vitae consectetur pharetra, tristique non nisi.
  </div>
</div>
```

You can also show a list of attributes, useful if you don't need to change any configuration:

```erb
<%= show_for @admin do |a| %>
  <%= a.attributes :name, :confirmed?, :created_at %>
<% end %>
```

## Value lookup

ShowFor uses the following sequence to get the attribute value:

* use the output of a block argument if given
* use the output of the `:value` argument if given
* check if a `:"human_#{attribute}"` method is defined
* retrieve the attribute directly.

## Options

ShowFor handles a series of options. Those are:

* __:format__ - Sent to `I18n.localize` when the attribute is a date/time object.

* __:value__ - Can be used instead of block. If a `Symbol` is called as instance method.

* __:if_blank__ - An object to be used if the value is blank. Not escaped as well.

* __:separator__ - The piece of html that separates label and content, overriding the global configuration.

In addition, all containers (`:label`, `:content` and `:wrapper`) can have their html
options configured through the `:label_html`, `:content_html` and `:wrapper_html`
options. Containers can have their tags configured on demand as well through
`:label_tag,` `:content_tag` and `:wrapper_tag` options.

## Label

ShowFor also exposes the label method. In case you want to use the default
`human_attribute_name` lookup and the default wrapping:

```ruby
a.label :name                  #=> <strong class="label">Name</strong>
a.label "Name", id: "my_name"  #=> <strong class="label" id="my_name">Name</strong>
```

Optionally, if you want to wrap the inner part of the label with some text
(e.g. adding a semicolon), you can do so by specifying a proc for `ShowFor.label_proc`
that will be called with any label text. E.g.:

```ruby
  ShowFor.label_proc = lambda { |l| l + ":" }
```

When taking this route, you can also skip on a per label basis by passing the
`:wrap_label` option with a value of false.

## Associations

ShowFor also supports associations.

```erb
<%= show_for @artwork do |a| %>
  <%= a.association :artist %>
  <%= a.association :artist, using: :name_with_title %>
  <%= a.attribute :name_with_title, in: :artist %>

  <%= a.association :tags %>
  <%= a.association :tags, to_sentence: true %>
  <%= a.association :tags do
    @artwork.tags.map(&:name).to_sentence
  end %>

  <%= a.association :fans, collection_tag: :ol do |fan| %>
    <li><%= link_to fan.name, fan %></li>
  <% end %>
<% end %>
```

The first is a `has_one` or `belongs_to` association, which works like an attribute
to ShowFor, except it will retrieve the artist association and try to find a
proper method from `ShowFor.association_methods` to be used. You can pass
the option :using to tell (and not guess) which method from the association
to use.

:tags is a `has_and_belongs_to_many` association which will return a collection.
ShowFor can handle collections by default by wrapping them in list (`<ul>` with
each item wrapped by an `<li>`). However, it also allows you to give `:to_sentence`
or `:join` it you want to render them inline.

You can also pass a block which expects an argument to association. In such cases,
a wrapper for the collection is still created and the block just iterates over the
collection objects.

Here are some other examples of the many possibilites to custom the output content:

```erb
<%= u.association :relationships, label: 'test' do  %>
  <% @user.relationships.each do |relation| %>
    <%= relation.related_user.name if relation.related_user_role == 'supervisor' %>
  <% end %>
<% end %>

<%= u.attribute :gender do  %>
  <%= content_tag :span, t("helpers.enum_select.user.gender.#{@user.gender}") %>
<% end %>
```

## Maintainers

* José Valim (http://github.com/josevalim)
* Carlos Antonio da Silva (https://github.com/carlosantoniodasilva)

## Contributors

* Jonas Grimfelt (http://github.com/grimen)

## Supported Ruby / Rails versions

We intend to maintain support for all Ruby / Rails versions that haven't reached end-of-life.

For more information about specific versions please check [Ruby](https://www.ruby-lang.org/en/downloads/branches/)
and [Rails](https://guides.rubyonrails.org/maintenance_policy.html) maintenance policies, and our test matrix.

## Bugs and Feedback

If you discover any bugs or want to drop a line, feel free to create an issue on GitHub.

http://github.com/heartcombo/show_for/issues

MIT License. Copyright 2012-2019 Plataformatec. http://plataformatec.com.br
