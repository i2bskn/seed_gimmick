module SeedGimmick
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Create seed_dir of SeedGimmick."
      def create_seed_dir
        create_file File.join("db", "seeds", ".keep")
      end

      desc "Create config file of SeedGimmick."
      def create_config_file
        append_to_file File.join("db", "seeds.rb"), "SeedGimmick.bootstrap"
      end
    end
  end
end
