module MiscHelpers
  def store_translations(locale, translations, &block)
    begin
      I18n.backend.store_translations locale, translations
      yield
    ensure
      I18n.reload!
    end
  end

  def assert_no_select(selector, value=nil)
    assert_select(selector, text: value, count: 0)
  end

  def swap(object, new_values)
    old_values = {}
    new_values.each do |key, value|
      old_values[key] = object.send key
      object.send :"#{key}=", value
    end
    yield
  ensure
    old_values.each do |key, value|
      object.send :"#{key}=", value
    end
  end

  def with_attribute_for(object, attribute, options={}, &block)
    concat(show_for(object) do |o|
      concat o.attribute(attribute, options, &block)
    end)
  end

  def with_value_for(object, attribute, options={}, &block)
    concat(show_for(object) do |o|
      concat o.value(attribute, options, &block)
    end)
  end

  def with_association_for(object, association, options={}, &block)
    concat(show_for(object) do |o|
      concat o.association(association, options, &block)
    end)
  end

  def with_label_for(object, attribute, options={})
    concat(show_for(object) do |o|
      concat o.label(attribute, options)
    end)
  end

  def with_content_for(object, value, options={})
    concat(show_for(object) do |o|
      concat o.content(value, options)
    end)
  end

  def with_attributes_for(object, *attributes)
    concat(show_for(object) do |o|
      concat o.attributes(*attributes)
    end)
  end
end
