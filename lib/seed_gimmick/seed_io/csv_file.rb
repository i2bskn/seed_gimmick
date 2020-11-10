module SeedGimmick
  module SeedIO
    class CsvFile < Base
      def self.raw_data(array_of_hashes)
        columns = array_of_hashes.first.keys
        array_of_hashes.map(&:values).unshift(columns).map(&:to_csv).join
      end

      def load_data
        data = CSV.read(seed_file, headers: :first_row).map(&:to_hash) ||
               (raise LoadFailed.new(seed_file), "load failed: #{seed}")
        set_data(data)
        self
      end

      def dump_data(array_of_hashes)
        write_raw(self.class.raw_data(array_of_hashes))
        array_of_hashes.size
      end
    end
  end
end
