require 'test_helper'

class AttributeTest < ActionView::TestCase
  # COLLECTIONS
  test "show_for accepts an attribute as a collection" do
    with_attribute_for @user, :scopes
    assert_select "div.show_for div.wrapper ul.collection"
    assert_select "div.show_for div.wrapper ul.collection li", :count => 3
  end

  test "show_for accepts an attribute as a collection with a block to iterate the collection" do
    with_attribute_for @user, :scopes do |scope|
      content_tag :span, scope
    end
    assert_select "div.show_for div.wrapper ul.collection"
    assert_select "div.show_for div.wrapper ul.collection span", :count => 3
  end

  test "show_for treats symbol for :value as method on each element of collection" do
    with_attribute_for @user, :scopes, :value => :upcase
    @user.scopes.each do |scope|
      assert_select "div.show_for div.wrapper ul.collection", /#{scope.upcase}/
    end
  end

  test "show_for allows collection tag to be configured globally" do
    swap ShowFor, :collection_tag => :ol, :collection_class => "my_collection" do
      with_attribute_for @user, :scopes
      assert_select "div.show_for div.wrapper ol.my_collection"
    end
  end

  test "show_for allows collection class to be disabled globally" do
    swap ShowFor, :collection_tag => :ol, :collection_class => nil do
      with_attribute_for @user, :scopes
      assert_select "div.show_for div.wrapper ol"
      assert_no_select "ol[class]"
    end
  end

  test "show_for allows collection tag to be changed by attribute" do
    with_attribute_for @user, :scopes, :collection_tag => :ol
    assert_select "div.show_for div.wrapper ol.collection"
  end

  test "show_for allows collection tag html to be configured by attribute" do
    with_attribute_for @user, :scopes, :collection_html => { :id => "thecollection", :class => "special" }
    assert_select "div.show_for div.wrapper ul#thecollection.special.collection"
  end

  # CONTENT
  test "show_for allows content tag to be configured globally" do
    swap ShowFor, :content_tag => :span, :content_class => :my_content do
      with_attribute_for @user, :name
      assert_select "div.show_for div.wrapper span.my_content"
    end
  end

  test "show_for allows content class to be disabled globally" do
    swap ShowFor, :content_tag => :span, :content_class => nil do
      with_attribute_for @user, :name
      assert_select "div.show_for div.wrapper span"
      assert_no_select "span[class]"
    end
  end

  test "show_for allows content tag to be changed by attribute" do
    with_attribute_for @user, :name, :content_tag => :span
    assert_select "div.show_for div.wrapper span.content"
  end

  test "show_for allows content tag html to be configured by attribute" do
    with_attribute_for @user, :name, :content_tag => :span, :content_html => { :id => "thecontent", :class => "special" }
    assert_select "div.show_for div.wrapper span#thecontent.special.content"
  end

  test "show_for accepts an attribute as string" do
    with_attribute_for @user, :name
    assert_select "div.show_for div.wrapper", /ShowFor/
  end

  test "show_for accepts an attribute as time" do
    with_attribute_for @user, :created_at
    assert_select "div.show_for div.wrapper", /#{Regexp.escape(I18n.l(@user.created_at))}/
  end

  test "show_for accepts an attribute as date" do
    with_attribute_for @user, :updated_at
    assert_select "div.show_for div.wrapper", /#{Regexp.escape(I18n.l(@user.updated_at))}/
  end

  test "show_for accepts an attribute as time with format options" do
    with_attribute_for @user, :created_at, :format => :long
    assert_select "div.show_for div.wrapper", /#{Regexp.escape(I18n.l(@user.created_at, :format => :long))}/
  end

  test "show_for accepts an attribute as true" do
    with_attribute_for @user, :active
    assert_select "div.show_for div.wrapper", /Yes/
  end

  test "show_for accepts an attribute as true which can be localized" do
    store_translations(:en, :show_for => { :yes => "Hell yeah!" }) do
      with_attribute_for @user, :active
      assert_select "div.show_for div.wrapper", /Hell yeah!/
    end
  end

  test "show_for accepts an attribute as false" do
    with_attribute_for @user, :invalid
    assert_select "div.show_for div.wrapper", /No/
  end

  test "show_for accepts an attribute as false which can be localized" do
    store_translations(:en, :show_for => { :no => "Hell no!" }) do
      with_attribute_for @user, :invalid
      assert_select "div.show_for div.wrapper", /Hell no!/
    end
  end

  test "show_for accepts nil and or blank attributes" do
    with_attribute_for @user, :description
    assert_select "div.show_for div.wrapper", /Not specified/
  end

  test "show_for accepts not spcified message can be localized" do
    store_translations(:en, :show_for => { :blank => "OMG! It's blank!" }) do
      with_attribute_for @user, :description
      assert_select "div.show_for div.wrapper", /OMG! It's blank!/
    end
  end

  test "show_for accepts not spcified message can be localized with html" do
    store_translations(:en, :show_for => { :blank_html => "<span>OMG! It's blank!</span>" }) do
      with_attribute_for @user, :description
      assert_select "div.show_for div.wrapper span", "OMG! It's blank!"
    end
  end

  test "show_for uses :if_blank if attribute is blank" do
    with_attribute_for @user, :description, :if_blank => "No description provided"
    assert_select "div.show_for div.wrapper", /No description provided/
  end

  test "show_for accepts a block to supply the content" do
    with_attribute_for @user, :description do
      "This description is not blank"
    end
    assert_select "div.show_for div.wrapper", /This description/
  end

  test "show_for uses :if_blank if the block content is blank" do
    with_attribute_for @user, :description, :if_blank => "No description provided" do
      ""
    end
    assert_select "div.show_for div.wrapper", /No description provided/
  end

  test "show_for#content given a block should be wrapped in the result" do
    with_attribute_for @user, :name do |name|
      "<div class='block'>#{name}</div>".html_safe
    end
    assert_select "div.wrapper.user_name div.block", /ShowFor/
  end

  test "show_for escapes content by default" do
    @user.name = "<b>hack you!</b>"
    with_attribute_for @user, :name
    assert_no_select "div.show_for div.wrapper b"
    assert_select "div.show_for div.wrapper",
      rails_42? ? "Super User Name!<b>hack you!</b>" : "Super User Name!&lt;b&gt;hack you!&lt;/b&gt;"
  end

  test "show_for works with html_safe marked strings" do
    @user.name = "<b>hack you!</b>".html_safe
    with_attribute_for @user, :name
    assert_select "div.show_for div.wrapper b", "hack you!"
  end

  test "show_for uses :value if supplied" do
    with_attribute_for @user, :name, :value => "Calculated Value"
    assert_select "div.show_for div.wrapper", /Calculated Value/
  end

  test "show_for uses :value and casts to string if supplied" do
    with_attribute_for @user, :name, :value => 123
    assert_select "div.show_for div.wrapper", /123/
  end

  test "show_for ignores :value if a block is supplied" do
    with_attribute_for @user, :name, :value => "Calculated Value" do
      @user.name.upcase
    end
    assert_select "div.show_for div.wrapper", /#{@user.name.upcase}/
  end

  test "show_for treats symbol for :value as method on attribute" do
    with_attribute_for @user, :name, :value => :upcase
    assert_select "div.show_for div.wrapper", /#{@user.name.upcase}/
  end

  test "show_for tries to translate the attribute value" do
    with_attribute_for @user, :state
    assert_select "div.show_for div.wrapper", /My Approved/
  end

  test "show_for does not display blank attribute if skip_blanks option is passed" do
    swap ShowFor, :skip_blanks => true do
      with_attribute_for @user, :description
      assert_no_select "div.show_for div.wrapper"
    end
  end

  test "show_for display false attribute if skip_blanks option is passed" do
    swap ShowFor, :skip_blanks => true do
      with_attribute_for @user, :invalid
      assert_select "div.show_for div.wrapper", /No/
    end
  end

  # ATTRIBUTES
  test "show_for attributes wraps each attribute with a label and content" do
    with_attributes_for @user, :name, :email
    assert_select "div.show_for div.user_name.wrapper", /ShowFor/
    assert_select "div.user_name strong.label", "Super User Name!"
    assert_select "div.show_for div.user_email.wrapper", /Not specified/
    assert_select "div.user_email strong.label", "Email"
  end

  test "show_for should wrap blank attributes with no_attribute" do
    swap ShowFor, :blank_content_class => 'no_attribute' do
      with_attributes_for @user, :name, :birthday
      assert_select ".wrapper.user_birthday.no_attribute"
      assert_select ".wrapper.user_name.no_attribute", false
    end
  end

end
