module SeedGimmick
  module SeedIO
    class YamlFile < Base
      class << self
        def raw_data(array_of_hashes)
          data = {}
          array_of_hashes.each.with_index(1) do |row, i|
            data[data_key(i)] = row
          end
          data.to_yaml
        end

        def data_key(id)
          "data%d" % id
        end
      end

      def load_data
        data = YAML.load_file(seed_file) || (raise LoadFailed.new(seed_file))
        set_data(data.values)
        self
      end

      def dump_data(array_of_hashes)
        write_raw(self.class.raw_data(array_of_hashes))
        array_of_hashes.size
      end
    end
  end
end

