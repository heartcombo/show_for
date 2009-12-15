require 'rubygems'
require 'test/unit'

require 'action_controller'
require 'action_view/test_case'

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

  tests ShowFor::FormHelper

  setup :setup_new_user

  def setup_new_user(options={})
    @user = User.new({
      :id => 1,
      :name => 'ShowFor',
      :description => 'Hello',
      :created_at => Time.now
    }.merge(options))
  end
end
