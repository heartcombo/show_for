require "test_helper"

class CustomBuilder < ShowFor::Builder
end

class HelperTest < ActionView::TestCase
  test "show for yields an instance of ShowFor::Builder" do
    show_for(@user) do |f|
      assert f.instance_of?(ShowFor::Builder)
    end
  end

  test "show for yields an instance of builder class specified by builder option" do
    show_for(@user, :builder => CustomBuilder) do |f|
      assert f.instance_of?(CustomBuilder)
    end
  end

  test "show for should add default class to form" do
    concat(show_for(@user) do |f| end)
    assert_select "div.show_for"
  end

  test "show for should add object class name as css class to form" do
    concat(show_for(@user) do |f| end)
    assert_select "div.show_for.user"
  end

  test "show for should pass options" do
    concat(show_for(@user, :id => "my_div", :class => "common") do |f| end)
    assert_select "div#my_div.show_for.user.common"
  end

  test "show for tag should be configurable" do
    swap ShowFor, :show_for_tag => :p do
      concat(show_for(@user) do |f| end)
      assert_select "p.show_for"
    end
  end

  test "show for class should be configurable" do
    swap ShowFor, :show_for_class => :awesome do
      concat(show_for(@user) do |f| end)
      assert_select "div.show_for.user.awesome"
    end
  end
  
  test "show for options hash should not be modified" do
    html_options = { :show_for_tag => :li }
    concat(show_for(@user, html_options) do |f| end)
    assert_equal({ :show_for_tag => :li }, html_options)
  end
  
end
