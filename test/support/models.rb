require 'ostruct'
require 'delegate'

class Company < Struct.new(:id, :name)
  extend ActiveModel::Naming

  def alternate_name
    "Alternate #{self.name}"
  end
end

class Tag < Struct.new(:id, :name)
  extend ActiveModel::Naming

  def self.all(options={})
    (1..3).map{ |i| Tag.new(i, "Tag #{i}") }
  end

  def alternate_name
    "Alternate #{self.name}"
  end
end

class Money < SimpleDelegator
  def to_s
    "$#{__getobj__}"
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
    Company.new(1, "PlataformaTec")
  end

  def net_worth
    Money.new(12_345_678)
  end

  def self.human_attribute_name(attribute)
    case attribute
      when 'name'
        'Super User Name!'
      when 'company'
        'Company Human Name!'
      else
        attribute.humanize
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
