require 'rubygems'
require 'test/unit'

require 'active_model'
require 'action_controller'
require 'action_view/test_case'

require 'rails/railtie'
require 'rails/backtrace_cleaner'

begin
  require 'ruby-debug'
rescue LoadError
end

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib', 'show_for')
require 'show_for'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each { |f| require f }
I18n.default_locale = :en

class ActionView::TestCase
  include MiscHelpers

  tests ShowFor::Helper

  setup :setup_new_user

  def setup_new_user(options={})
    @user = User.new({
      :id => 1,
      :name => 'ShowFor',
      :description => '',
      :active => true,
      :invalid => false,
      :scopes => ["admin", "manager", "visitor"],
      :created_at => Time.now,
      :updated_at => Date.today
    }.merge(options))
  end
end
