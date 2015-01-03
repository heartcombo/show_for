require 'test_helper'

class ValueTest < ActionView::TestCase
  test "show_for allows content tag to be configured globally, without label and separator" do
    swap ShowFor, :content_tag => :span do
      with_value_for @user, :name
      assert_no_select "div.show_for div.wrapper strong.label"
      assert_no_select "div.show_for div.wrapper br"
      assert_select "div.show_for div.wrapper span.content"
    end
  end

  test "show_for allows content with tag to be changed by attribute, without label and separator" do
    with_value_for @user, :name, :content_tag => :span
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_select "div.show_for div.wrapper span.content"
  end

  test "show_for allows content tag html to be configured by attribute, without label and separator" do
    with_value_for @user, :name, :content_tag => :span, :content_html => { :id => "thecontent", :class => "special" }
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_select "div.show_for div.wrapper span#thecontent.special.content"
  end

  test "show_for accepts an attribute as string, without label and separator" do
    with_value_for @user, :name
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_select "div.show_for div.wrapper", /ShowFor/
  end

  test "show_for accepts an attribute as time, without label and separator" do
    with_value_for @user, :created_at
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_select "div.show_for div.wrapper", /#{Regexp.escape(I18n.l(@user.created_at))}/
  end

  test "show_for accepts an attribute as date, without label and separator" do
    with_value_for @user, :updated_at
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_select "div.show_for div.wrapper", /#{Regexp.escape(I18n.l(@user.updated_at))}/
  end

  test "show_for accepts an attribute as time with format options, without label and separator" do
    with_value_for @user, :created_at, :format => :long
    assert_select "div.show_for div.wrapper", /#{Regexp.escape(I18n.l(@user.created_at, :format => :long))}/
  end

  test "show_for accepts an attribute as nil, without label and separator" do
    c = with_value_for @user, :birthday
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_select "div.show_for div.wrapper", /Not specified/
  end

  test "show_for accepts blank attributes, without label and separator" do
    with_value_for @user, :description
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_select "div.show_for div.wrapper", /Not specified/
  end

  test "show_for uses :if_blank if attribute is nil, without label and separator" do
    with_value_for @user, :birthday, :if_blank => "No description provided"
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_select "div.show_for div.wrapper", /No description provided/
  end

  test "show_for uses :if_blank if attribute is blank, without label and separator" do
    with_value_for @user, :description, :if_blank => "No description provided"
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_select "div.show_for div.wrapper", /No description provided/
  end

  test "show_for escapes content by default, without label and separator" do
    @user.name = "<b>hack you!</b>"
    with_value_for @user, :name
    assert_no_select "div.show_for div.wrapper strong.label"
    assert_no_select "div.show_for div.wrapper br"
    assert_no_select "div.show_for div.wrapper b"
    assert_select "div.show_for div.wrapper", /&lt;b&gt;/
  end
end
