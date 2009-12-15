class ShowForInstallGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory 'config/initializers'
      m.template  'show_for.rb', 'config/initializers/show_for.rb'

      m.directory 'config/locales'
      m.template  locale_file, 'config/locales/show_for.en.yml'
    end
  end

  private

    def locale_file
      @locale_file ||= '../../../lib/show_for/locale/en.yml'
    end

end
