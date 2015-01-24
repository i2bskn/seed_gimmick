require "seed_gimmick/seed_io/base"
require "seed_gimmick/seed_io/yaml_file"

module SeedGimmick
  module SeedIO
    class << self
      def get(seed_file)
        const_get(io_class_name_for(seed_file), false).new(seed_file)
      end

      private
        def io_class_name_for(seed_file)
          ext = Inflector.pathname(seed_file).extname.sub(/\A\./, "")
          ext = "yaml" if ext == "yml"
          "%sFile" % ext.capitalize
        end
    end
  end
end

