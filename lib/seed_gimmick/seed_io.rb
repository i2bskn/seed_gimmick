require "seed_gimmick/seed_io/base"
require "seed_gimmick/seed_io/yaml_file"
require "seed_gimmick/seed_io/csv_file"

module SeedGimmick
  module SeedIO
    module ExtType
      # Collection map
      # @note Require Symbol keys and String values.
      CORRECTION = {
        yml: "yaml",
      }.freeze

      # Corrected the fluctuation of extension.
      # @param seed_file [String]
      # @param seed_file [Pathname]
      # @return [String]
      def self.decision(path)
        ext = Inflector.ext_type(path)
        CORRECTION[ext].presence || ext.to_s
      end
    end

    class << self
      # Generate of IO class from seed_file path.
      # @param seed_file [String]
      # @param seed_file [Pathname]
      # @return [SeedIO] Target IO class.
      def factory(seed_file)
        seed_file = Inflector.pathname(seed_file) || (raise ArgumentError)
        const_get(io_class_name_for(seed_file), false).new(seed_file)
      end

      private
        # Convert seed_file path to IO class name.
        # @param seed_file [Pathname]
        # @return [String] Target IO class name.
        def io_class_name_for(seed_file)
          "%sFile" % ExtType.decision(seed_file).capitalize
        end
    end
  end
end

