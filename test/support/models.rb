require 'ostruct'

class Company
  extend ActiveModel::Naming

  attr_accessor :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def alternate_name
    "Alternate #{self.name}"
  end
end

class FakeCollectionProxy
  include Enumerable

  def initialize(collection)
    @collection = collection
  end

  def each(&block)
    @collection.each(&block)
  end

  alias :load_target :to_a
end

class Tag
  extend ActiveModel::Naming

  attr_accessor :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

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
    FakeCollectionProxy.new(Tag.all)
  end

  def company
    Company.new(1, "PlataformaTec")
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
