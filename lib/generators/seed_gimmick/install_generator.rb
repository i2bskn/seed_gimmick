module SeedGimmick
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      desc "Create seed_dir of SeedGimmick."
      def create_seed_dir
        create_file File.join("db", "seed_gimmick", ".keep")
      end

      desc "Create custom seeds script."
      def create_custom_seeds_script
        template "seeds.rb", "db/seeds.rb"
      end
    end
  end
end

