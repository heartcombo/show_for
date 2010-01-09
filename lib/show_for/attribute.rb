module ShowFor
  module Attribute
    def attribute(attribute_name, options={}, &block)
      apply_default_options!(attribute_name, options)
      collection_block, block = block, nil if collection_block?(block)

      value = if block
        block
      elsif @object.respond_to?(:"human_#{attribute_name}")
        @object.send :"human_#{attribute_name}"
      else
        @object.send(attribute_name)
      end

      wrap_label_and_content(attribute_name, value, options, &collection_block)
    end 
  end
end