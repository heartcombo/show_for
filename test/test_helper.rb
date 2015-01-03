require 'bundler/setup'

require 'minitest/autorun'

require 'active_model'
require 'action_controller'
require 'action_view'
require 'action_view/template'
require 'action_view/test_case'

require "rails/generators/test_case"
require 'generators/show_for/install_generator'

$:.unshift File.expand_path("../../lib", __FILE__)
require 'show_for'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each { |f| require f }
I18n.enforce_available_locales = true
I18n.default_locale = :en

ActiveSupport::TestCase.test_order = :random if ActiveSupport::TestCase.respond_to?(:test_order=)

class ActionView::TestCase
  include MiscHelpers
  include ShowFor::Helper

  setup :setup_new_user

  def setup_new_user(options={})
    @user = User.new({
      :id => 1,
      :name => 'ShowFor',
      :description => '',
      :active => true,
      :invalid => false,
      :scopes => ["admin", "manager", "visitor"],
      :birthday => nil,
      :created_at => Time.now,
      :updated_at => Date.today
    }.merge(options))
  end
end
