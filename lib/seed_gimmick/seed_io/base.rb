module SeedGimmick
  module SeedIO
    class Base
      BASE_DATA_KEYS = %i(values metadata).freeze

      attr_reader *[:seed_file].concat(BASE_DATA_KEYS)

      # Data access callbacks.
      BASE_DATA_KEYS.each do |key|
        define_method "#{key}_with_load_if_not_data" do
          public_send("#{key}_without_load_if_not_data") || load_data[key]
        end
        alias_method_chain key, :load_if_not_data
      end

      # @param seed_file [Pathname]
      def initialize(seed_file)
        @seed_file = seed_file
      end

      # Data load from seed file.
      # @note Need to return self or load data with Hash.
      def load_data
        raise NotImplementedError
      end

      # Data dump to seed file.
      # @param array_of_hashes [Array<Hash>]
      def dump_data(array_of_hashes)
        raise NotImplementedError
      end

      # Data access with bracket.
      def [](key)
        raise ArgumentError unless BASE_DATA_KEYS.include?(key)
        public_send(key.to_sym)
      end

      private
        # Update accessible data from Array of Hashes.
        # @param array_of_hashes [Array<Hash>] loaded data.
        def set_data(array_of_hashes)
          @values = array_of_hashes
          @metadata = {
            rows: @values.size,
          }
        end

        def write_raw(data)
          seed_file.dirname.mkpath
          seed_file.open("w") {|f| f.write data }
        end
    end
  end
end

