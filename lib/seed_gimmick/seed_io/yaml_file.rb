module SeedGimmick
  module SeedIO
    class YamlFile < Base
      def load_data
        data = YAML.load_file(seed_file) || (raise LoadFailed.new(seed_file))
        data.values
      end
    end
  end
end

