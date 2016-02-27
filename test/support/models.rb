require 'ostruct'

Company = Struct.new(:id, :name) do
  extend ActiveModel::Naming

  def alternate_name
    "Alternate #{self.name}"
  end
end


Tag = Struct.new(:id, :name) do
  extend ActiveModel::Naming

  def self.all(options={})
    (1..3).map{ |i| Tag.new(i, "Tag #{i}") }
  end

  def alternate_name
    "Alternate #{self.name}"
  end
end

class User < OpenStruct
  extend ActiveModel::Naming

  # Get rid of deprecation warnings
  undef_method :id if respond_to?(:id)

  def tags
    Tag.all
  end

  def company
    Company.new(1, "Plataformatec")
  end

  def self.human_attribute_name(attribute, options = {})
    case attribute
      when 'name'
        'Super User Name!'
      when 'company'
        'Company Human Name!'
      when 'state/approved'
        "My Approved"
      else
        options.has_key?(:default) ? options[:default] : attribute.humanize
    end
  end

  def self.human_name
    "User"
  end
end

module Namespaced
  class User < ::User
  end
end
