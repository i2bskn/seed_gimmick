module SeedGimmick
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      desc "Create seed_dir of SeedGimmick."
      def create_seed_dir
        create_file File.join("db", "seed_gimmick", ".keep")
      end

      desc "Create config file of SeedGimmick."
      def create_config_file
        template "seed_gimmick.yml", "config/seed_gimmick.yml"
      end
    end
  end
end
