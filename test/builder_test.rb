require 'test_helper'

class BuilderTest < ActionView::TestCase

  def with_attribute_for(object, attribute, options={}, &block)
    show_for(object) do |o|
      o.attribute(attribute, options, &block)
    end
  end

  def with_association_for(object, association, options={}, &block)
     show_for(object) do |o|
       o.association(association, options, &block)
     end
   end

  def with_label_for(object, attribute, options={})
    show_for(object) do |o|
      o.label attribute, options
    end
  end

  def with_content_for(object, value, options={})
    show_for(object) do |o|
      o.content value, options
    end
  end

  # WRAPPER 
  test "show_for attribute wraps each attribute with a label and content" do
    with_attribute_for @user, :name
    assert_select "div.show_for p.user_name.wrapper"
    assert_select "div.show_for p.wrapper strong.label"
    assert_select "div.show_for p.wrapper"
  end

  test "show_for allows wrapper tag to be changed by attribute" do
    with_attribute_for @user, :name, :wrapper_tag => :span
    assert_select "div.show_for span.user_name.wrapper"
  end

  test "show_for allows wrapper html to be configured by attribute" do
    with_attribute_for @user, :name, :wrapper_html => { :id => "thewrapper", :class => "special" }
    assert_select "div.show_for p#thewrapper.user_name.wrapper.special"
  end

  # SEPARATOR
  test "show_for uses a separator if requested" do
    with_attribute_for @user, :name
    assert_select "div.show_for p.wrapper br"
  end

  test "show_for does not blow if a separator is not set" do
    swap ShowFor, :separator => nil do
      with_attribute_for @user, :name
      assert_select "div.show_for p.wrapper"
    end
  end

  # LABEL
  test "show_for shows a label using the humanized attribute name from model" do
    with_attribute_for @user, :name
    assert_select "div.show_for p.wrapper strong.label", "Super User Name!"
  end

  test "show_for skips label if requested" do
    with_attribute_for @user, :name, :label => false
    assert_no_select "div.show_for p.wrapper strong.label"
  end

  test "show_for allows label to be configured globally" do
    swap ShowFor, :label_tag => :span do
      with_attribute_for @user, :name
      assert_select "div.show_for p.wrapper span.label"
    end
  end

  test "show_for allows label to be changed by attribute" do
    with_attribute_for @user, :name, :label_tag => :span
    assert_select "div.show_for p.wrapper span.label"
  end

  test "show_for allows label html to be configured by attribute" do
    with_attribute_for @user, :name, :label_html => { :id => "thelabel", :class => "special" }
    assert_select "div.show_for p.wrapper strong#thelabel.special.label"
  end

  test "show_for allows label to be set without lookup" do
    with_attribute_for @user, :name, :label => "Special Label"
    assert_select "div.show_for p.wrapper strong.label", "Special Label"
  end

  test "show_for#label accepts the text" do
    with_label_for @user, "Special Label"
    assert_select "div.show_for strong.label", "Special Label"
  end

  test "show_for#label accepts an attribute name" do
    with_label_for @user, :name
    assert_select "div.show_for strong.label", "Super User Name!"
  end

  test "show_for#label accepts html options" do
    with_label_for @user, :name, :id => "thelabel", :class => "special"
    assert_select "div.show_for strong#thelabel.special.label"
  end

  # CONTENT
  test "show_for allows content tag to be configured globally" do
    swap ShowFor, :content_tag => :span do
      with_attribute_for @user, :name
      assert_select "div.show_for p.wrapper span.content"
    end
  end

  test "show_for allows content tag to be changed by attribute" do
    with_attribute_for @user, :name, :content_tag => :span
    assert_select "div.show_for p.wrapper span.content"
  end

  test "show_for allows content tag html to be configured by attribute" do
    with_attribute_for @user, :name, :content_tag => :span, :content_html => { :id => "thecontent", :class => "special" }
    assert_select "div.show_for p.wrapper span#thecontent.special.content"
  end

  test "show_for accepts an attribute as string" do
    with_attribute_for @user, :name
    assert_select "div.show_for p.wrapper", /ShowFor/
  end

  test "show_for accepts an attribute as time" do
    with_attribute_for @user, :created_at
    assert_select "div.show_for p.wrapper", /#{Regexp.escape(I18n.l(@user.created_at))}/
  end

  test "show_for accepts an attribute as date" do
    with_attribute_for @user, :updated_at
    assert_select "div.show_for p.wrapper", /#{Regexp.escape(I18n.l(@user.updated_at))}/
  end

  test "show_for accepts an attribute as time with format options" do
    with_attribute_for @user, :created_at, :format => :long
    assert_select "div.show_for p.wrapper", /#{Regexp.escape(I18n.l(@user.created_at, :format => :long))}/
  end

  test "show_for accepts an attribute as true" do
    with_attribute_for @user, :active
    assert_select "div.show_for p.wrapper", /Yes/
  end

  test "show_for accepts an attribute as true which can be localized" do
    store_translations(:en, :show_for => { :yes => "Hell yeah!" }) do
      with_attribute_for @user, :active
      assert_select "div.show_for p.wrapper", /Hell yeah!/
    end
  end

  test "show_for accepts an attribute as false" do
    with_attribute_for @user, :invalid
    assert_select "div.show_for p.wrapper", /No/
  end

  test "show_for accepts an attribute as false which can be localized" do
    store_translations(:en, :show_for => { :no => "Hell no!" }) do
      with_attribute_for @user, :invalid
      assert_select "div.show_for p.wrapper", /Hell no!/
    end
  end

  test "show_for accepts nil and or blank attributes" do
    with_attribute_for @user, :description
    assert_select "div.show_for p.wrapper", /Not specified/
  end

  test "show_for accepts not spcified message can be localized" do
    store_translations(:en, :show_for => { :blank => "OMG! It's blank!" }) do
      with_attribute_for @user, :description
      assert_select "div.show_for p.wrapper", /OMG! It's blank!/
    end
  end

  test "show_for uses :if_blank if attribute is blank" do
    with_attribute_for @user, :description, :if_blank => "No description provided"
    assert_select "div.show_for p.wrapper", /No description provided/
  end

  test "show_for accepts a block to supply the content" do
    with_attribute_for @user, :description do
      "This description is not blank"
    end
    assert_select "div.show_for p.wrapper", /This description/
  end

  test "show_for escapes content by default" do
    @user.name = "<b>hack you!</b>"
    with_attribute_for @user, :name
    assert_no_select "div.show_for p.wrapper b"
    assert_select "div.show_for p.wrapper", /&lt;b&gt;/
  end

  test "show_for does not escape content if chosen" do
    @user.name = "<b>hack you!</b>"
    with_attribute_for @user, :name, :escape => false
    assert_select "div.show_for p.wrapper b", "hack you!"
  end

  test "show_for#content accepts any object" do
    with_content_for @user, "Special content"
    assert_select "div.show_for", "Special content"
  end

  test "show_for#content accepts :if_blank as option" do
     with_content_for @user, "", :if_blank => "Got blank"
     assert_select "div.show_for", "Got blank"
   end

  test "show_for#content accepts html options" do
    with_content_for @user, "Special content", :content_tag => :b, :id => "thecontent", :class => "special"
    assert_select "div.show_for b#thecontent.special.content", "Special content"
  end
  
  test "show_for#content with blank value has a 'no value'-class" do
    swap ShowFor, :blank_content_class => "nothing" do
      with_content_for @user, nil, :content_tag => :b
      assert_select "div.show_for b.nothing"
    end
  end

  test "show_for#content with blank value fallbacks on a default value" do
    swap ShowFor, :blank_content => "Not specified" do
      with_content_for @user, nil, :content_tag => :b
      assert_select "div.show_for b", "Not specified"
    end
  end

  # COLLECTIONS
  test "show_for accepts an attribute as a collection" do
    with_attribute_for @user, :scopes
    assert_select "div.show_for p.wrapper ul.collection"
    assert_select "div.show_for p.wrapper ul.collection li", :count => 3
  end

  test "show_for accepts an attribute as a collection with a block to iterate the collection" do
    with_attribute_for @user, :scopes do |scope|
      content_tag :span, scope
    end
    assert_select "div.show_for p.wrapper ul.collection"
    assert_select "div.show_for p.wrapper ul.collection span", :count => 3
  end

  test "show_for allows collection tag to be configured globally" do
    swap ShowFor, :collection_tag => :ol do
      with_attribute_for @user, :scopes
      assert_select "div.show_for p.wrapper ol.collection"
    end
  end

  test "show_for allows collection tag to be changed by attribute" do
    with_attribute_for @user, :scopes, :collection_tag => :ol
    assert_select "div.show_for p.wrapper ol.collection"
  end

  test "show_for allows collection tag html to be configured by attribute" do
    with_attribute_for @user, :scopes, :collection_html => { :id => "thecollection", :class => "special" }
    assert_select "div.show_for p.wrapper ul#thecollection.special.collection"
  end

  # ASSOCIATIONS
  test "show_for works with belongs_to/has_one associations" do
    with_association_for @user, :company
    assert_select "div.show_for p.wrapper", /PlataformaTec/
  end

  test "show_for accepts :using as option to tell how to retrieve association value" do
    with_association_for @user, :company, :using => :alternate_name
    assert_select "div.show_for p.wrapper", /Alternate PlataformaTec/
  end

  test "show_for accepts :in to tell to retrieve an attribute from association" do
    with_attribute_for @user, :alternate_name, :in => :company
    assert_select "div.show_for p.wrapper", /Alternate PlataformaTec/
  end

  test "show_for forwards all options send with :in to association" do
    with_attribute_for @user, :alternate_name, :in => :tags, :to_sentence => true
    assert_no_select "div.show_for p.wrapper ul.collection"
    assert_select "div.show_for p.wrapper", /Alternate Tag 1, Alternate Tag 2, and Alternate Tag 3/
  end

  test "show_for works with has_many/has_and_belongs_to_many associations" do
    with_association_for @user, :tags
    assert_select "div.show_for p.wrapper ul.collection"
    assert_select "div.show_for p.wrapper ul.collection li", "Tag 1"
    assert_select "div.show_for p.wrapper ul.collection li", "Tag 2"
    assert_select "div.show_for p.wrapper ul.collection li", "Tag 3"
  end

  test "show_for accepts :using as option to tell how to retrieve association values" do
    with_association_for @user, :tags, :using => :alternate_name
    assert_select "div.show_for p.wrapper ul.collection"
    assert_select "div.show_for p.wrapper ul.collection li", "Alternate Tag 1"
    assert_select "div.show_for p.wrapper ul.collection li", "Alternate Tag 2"
    assert_select "div.show_for p.wrapper ul.collection li", "Alternate Tag 3"
  end

  test "show_for accepts :to_sentence as option in collection associations" do
    with_association_for @user, :tags, :to_sentence => true
    assert_no_select "div.show_for p.wrapper ul.collection"
    assert_select "div.show_for p.wrapper", /Tag 1, Tag 2, and Tag 3/
  end

  test "show_for accepts :join as option in collection associations" do
    with_association_for @user, :tags, :join => ", "
    assert_no_select "div.show_for p.wrapper ul.collection"
    assert_select "div.show_for p.wrapper", /Tag 1, Tag 2, Tag 3/
  end

  test "show_for accepts a block without argument in collection associations" do
    with_association_for @user, :tags do
      @user.tags.map(&:name).to_sentence
    end
    assert_no_select "div.show_for p.wrapper ul.collection"
    assert_select "div.show_for p.wrapper", /Tag 1, Tag 2, and Tag 3/
  end

  test "show_for accepts a block with argument in collection associations" do
    with_association_for @user, :tags, :collection_tag => :p do |tag|
      assert_kind_of Tag, tag
      content_tag(:span, tag.name)
    end
    assert_no_select "div.show_for p.wrapper ul.collection"
    assert_select "div.show_for p.wrapper p.collection"
    assert_select "div.show_for p.wrapper p.collection span", "Tag 1"
    assert_select "div.show_for p.wrapper p.collection span", "Tag 2"
    assert_select "div.show_for p.wrapper p.collection span", "Tag 3"
  end
end