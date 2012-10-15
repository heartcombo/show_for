require 'test_helper'

class ShowForGeneratorTest < Rails::Generators::TestCase
  tests ShowFor::Generators::InstallGenerator
  destination File.expand_path('../../tmp', __FILE__)
  setup :prepare_destination
  teardown { rm_rf(destination_root) }

  test 'generates example locale file' do
    run_generator
    assert_file 'config/locales/show_for.en.yml'
  end

  test 'generates the show_for initializer' do
    run_generator
    assert_file 'config/initializers/show_for.rb',
      /config.show_for_tag = :div/
  end

  %W(erb haml).each do |engine|
    test "generates the scaffold template when using #{engine}" do
      run_generator ['-e', engine]
      assert_file "lib/templates/#{engine}/scaffold/show.html.#{engine}"
    end
  end
end
