module SeedGimmick
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      desc "Install SeedGimmick files"
      def install_seed_gimmick_files
        template "seeds.rb", "db/seeds.rb"
      end
    end
  end
end

