module ShowFor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy ShowFor installation files"
      class_option :template_engine, :desc => 'Template engine to be invoked (erb or haml or slim).'
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializers
        copy_file 'show_for.rb', 'config/initializers/show_for.rb'
      end

      def copy_locale_file
        copy_file 'en.yml', 'config/locales/show_for.en.yml'
      end

      def copy_generator_template
        engine = options[:template_engine]
        copy_file "show.html.#{engine}", "lib/templates/#{engine}/scaffold/show.html.#{engine}"
      end
    end
  end
end
