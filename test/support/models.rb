require 'ostruct'

Column = Struct.new(:name, :type, :limit)
Association = Struct.new(:klass, :name, :macro, :options)

class Company < Struct.new(:id, :name)
  def self.all(options={})
    all = (1..3).map{|i| Company.new(i, "Company #{i}")}
    return [all.first] if options[:conditions]
    return [all.last]  if options[:order]
    all
  end
end

class Tag < Struct.new(:id, :name)
  def self.all(options={})
    (1..3).map{|i| Tag.new(i, "Tag #{i}")}
  end
end

class User < OpenStruct
  # Get rid of deprecation warnings
  undef_method :id

  def self.human_attribute_name(attribute)
    case attribute
      when 'name'
        'Super User Name!'
      when 'description'
        'User Description!'
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
