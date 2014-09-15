require 'test_helper'

class BuilderTest < ActionView::TestCase
  # WRAPPER
  test "show_for allows wrapper to be configured globally" do
    swap ShowFor, :wrapper_tag => "li", :wrapper_class => "my_wrapper" do
      with_attribute_for @user, :name
      assert_select "div.show_for li.user_name.my_wrapper"
      assert_select "div.show_for li.my_wrapper strong.label"
      assert_select "div.show_for li.my_wrapper"
    end
  end

  test "show_for attribute wraps each attribute with a label and content" do
    with_attribute_for @user, :name
    assert_select "div.show_for p.user_name.wrapper"
    assert_select "div.show_for p.wrapper strong.label"
    assert_select "div.show_for p.wrapper"
  end

  test "show_for properly deals with namespaced models" do
    @user = Namespaced::User.new(:id => 1, :name => "ShowFor")

    with_attribute_for @user, :name
    assert_select "div.show_for p.namespaced_user_name.wrapper"
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
  test "show_for allows separator to be configured globally" do
    swap ShowFor, :separator => "<span class='separator'></span>" do
      with_attribute_for @user, :name
      assert_select "div.show_for p.user_name span.separator"
      assert_select "div.show_for p.wrapper span.separator"
    end
  end

  test "show_for allows separator to be changed by attribute"do
    with_attribute_for @user, :name, :separator => "<span class='separator'></span>"
    assert_select "div.show_for p.wrapper span.separator"
  end

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
end
