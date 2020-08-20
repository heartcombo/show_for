require 'test_helper'

class ContentTest < ActionView::TestCase
  test "show_for#content accepts any object" do
    with_content_for @user, "Special content"
    assert_select "div.show_for", "Special content"
  end

  test "show_for#content accepts :if_blank as option" do
     with_content_for @user, "", if_blank: "Got blank"
     assert_select "div.show_for", "Got blank"
   end

  test "show_for#content accepts html options" do
    with_content_for @user, "Special content", content_tag: :b, id: "thecontent", class: "special"
    assert_select "div.show_for b#thecontent.special.content", "Special content"
    assert_no_select "div.show_for b[content_tag]"
  end

  test "show_for#content with blank value has a 'no value'-class" do
    swap ShowFor, blank_content_class: "nothing" do
      with_content_for @user, nil, content_tag: :b
      assert_select "div.show_for b.nothing"
    end
  end

  test "show_for#content with blank value does not display content if skip_blanks option is passed" do
    swap ShowFor, skip_blanks: true do
      with_content_for @user, nil, content_tag: :b
      assert_no_select "div.show_for b"
    end
  end
end
