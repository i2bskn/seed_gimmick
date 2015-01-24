module SeedGimmick
  module SeedIO
    class YamlFile < Base
      def load_data
        data = YAML.load_file(seed_file) || (raise LoadFailed.new(seed_file))
        data.values
      end

      def dump_data(array_of_hashes)
        data = {}
        array_of_hashes.each.with_index(1) do |row, i|
          data[data_key(i)] = row
        end

        write_raw(data.to_yaml)
      end

      private
        def data_key(id)
          "data%d" % id
        end
    end
  end
end

