class ShowForInstallGenerator < Rails::Generators::Base
  def copy_initializers
    template 'show_for.rb', 'config/initializers/show_for.rb'
  end

  def copy_locale_file
    template '../../locale/en.yml', 'config/locales/show_for.en.yml'
  end
end
