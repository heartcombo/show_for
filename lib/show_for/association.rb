module ShowFor
  module Association
    def attribute(attribute_name, options={}, &block)
      if association_name = options.delete(:in)
        options[:using] = attribute_name
        association(association_name, options, &block)
      else
        super
      end
    end

    def association(association_name, options={}, &block)
      apply_default_options!(association_name, options)

      # If a block with an iterator was given, no need to calculate the labels
      # since we want the collection to be yielded. Otherwise, calculate the values.
      value = if collection_block?(block)
        collection_block = block
        @object.send(association_name)
      elsif block
        block
      else
        association = @object.send(association_name)
        values = values_from_association(association, options)

        if options.delete(:to_sentence)
          values.to_sentence
        elsif joiner = options.delete(:join)
          values.join(joiner)
        else
          values
        end
      end

      wrap_label_and_content(association_name, value, options, &collection_block)
    end

  protected

    def values_from_association(association, options) #:nodoc:
      sample = association.respond_to?(:to_ary) ? association.first : association
      method = options.delete(:using) || ShowFor.association_methods.find { |m| sample.respond_to?(m) }

      if method
        association.respond_to?(:to_ary) ? association.map(&method) : association.try(method)
      end
    end
  end
end
