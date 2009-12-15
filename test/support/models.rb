require 'ostruct'

class Company < Struct.new(:id, :name)
  def alternate_name
    "Alternate #{self.name}"
  end
end

class Tag < Struct.new(:id, :name)
  def self.all(options={})
    (1..3).map{ |i| Tag.new(i, "Tag #{i}") }
  end

  def alternate_name
    "Alternate #{self.name}"
  end
end

class User < OpenStruct
  # Get rid of deprecation warnings
  undef_method :id

  def tags
    Tag.all
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
