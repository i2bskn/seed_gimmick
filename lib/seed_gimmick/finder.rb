module SeedGimmick
  module Finder
    extend ActiveSupport::Concern

    module ClassMethods
      def find(options = nil)
        options ||= Options.new
        seed_files(options).map {|file| SeedFile.new(options.seed_dir, file) }
      end

      private
        def seed_files(options)
          Pathname.glob(options.seed_dir.join("**", "*")).select(&:file?)
        end
    end
  end
end

