module SeedGimmick
  module SeedIO
    class Base
      attr_reader :seed_file

      def initialize(seed_file)
        @seed_file = seed_file
      end

      def load_data
        raise NotImplementedError
      end

      def dump_data(array_of_hashes)
        raise NotImplementedError
      end

      private
        def write_raw(data)
          seed_file.dirname.mkpath
          seed_file.open("w") {|f| f.write data }
        end
    end
  end
end

