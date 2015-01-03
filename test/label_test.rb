require 'test_helper'

class LabelTest < ActionView::TestCase
  test "show_for shows a label using the humanized attribute name from model" do
    with_attribute_for @user, :name
    assert_select "div.show_for div.wrapper strong.label", "Super User Name!"
  end

  test "show_for skips label if requested" do
    with_attribute_for @user, :name, :label => false
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
  end

  test "show_for uses custom content_tag and skips label if requested" do
    with_attribute_for @user, :name, :label => false, :content_tag => :h2
    assert_select "div.show_for div.wrapper h2.content", "ShowFor"
  end

  test "show_for allows label to be configured globally" do
    swap ShowFor, :label_tag => :span, :label_class => "my_label" do
      with_attribute_for @user, :name
      assert_select "div.show_for div.wrapper span.my_label"
    end
  end

  test "show_for allows label to be changed by attribute" do
    with_attribute_for @user, :name, :label_tag => :span
    assert_select "div.show_for div.wrapper span.label"
  end

  test "show_for allows label html to be configured by attribute" do
    with_attribute_for @user, :name, :label_html => { :id => "thelabel", :class => "special" }
    assert_select "div.show_for div.wrapper strong#thelabel.special.label"
  end

  test "show_for allows label to be set without lookup" do
    with_attribute_for @user, :name, :label => "Special Label"
    assert_select "div.show_for div.wrapper strong.label", "Special Label"
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

  test "should let you override the label wrapper" do
    swap ShowFor, :label_proc => proc { |l| l + ":" } do
      with_label_for @user, "Special Label"
      assert_select "div.show_for strong.label", "Special Label:"
    end
  end

  test "should you skip wrapping the label on a per item basis" do
    swap ShowFor, :label_proc => proc { |l| l + ":" } do
      with_label_for @user, "Special Label", :wrap_label => false
      assert_select "div.show_for strong.label", "Special Label"
    end
  end
end
