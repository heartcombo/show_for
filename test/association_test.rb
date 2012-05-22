require 'test_helper'

class AssociationTest < ActionView::TestCase
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

  test "show_for works with has_many/has_and_belongs_to_many blank associations" do
    def @user.tags
      []
    end

    swap ShowFor, :association_methods => [:name] do
      with_association_for @user, :tags
      assert_no_select "div.show_for p.wrapper ul.collection"
      assert_no_select "div.show_for p.wrapper", /Enumerator/
    end
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
