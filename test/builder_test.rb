require 'test_helper'

class BuilderTest < ActionView::TestCase

  def with_attribute_for(object, attribute, options={})
    show_for object do |o|
      concat o.attribute attribute, options
    end
  end

  test "show_for attribute wraps each attribute with a label plus content" do
    with_attribute_for @user, :name
    assert_select "div.show_for p#user_name.wrapper"
    assert_select "div.show_for p.wrapper b.label", "Super User Name!"
    assert_select "div.show_for p.wrapper", /ShowFor/
  end

  test "show_for uses a separator when requested" do
    with_attribute_for @user, :name
    assert_select "div.show_for p.wrapper br"
  end
end