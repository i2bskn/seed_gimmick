module SeedGimmick
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Create seed_dir of SeedGimmick."
      def create_seed_dir
        create_file File.join("db", "seed_gimmick", ".keep")
      end
    end
  end
end

