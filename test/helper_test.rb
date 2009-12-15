require "test_helper"

class HelperTest < ActionView::TestCase
  test "show for yields an instance of ShowFor::Builder" do
    show_for @user do |f|
      assert f.instance_of?(ShowFor::Builder)
    end
  end

  test "show for should add default class to form" do
    show_for @user do |f| end
    assert_select "div.show_for"
  end

  test "show for should add object class name as css class to form" do
    show_for @user do |f| end
    assert_select "div.show_for.user"
  end

  test "show for should pass options" do
    show_for @user, :id => "my_div", :class => "common" do |f| end
    assert_select "div#my_div.show_for.user.common"
  end

  test "show for tag should be configurable" do
    swap ShowFor, :show_for_tag => :p do
      show_for @user do |f| end
      assert_select "p.show_for"
    end
  end
end
