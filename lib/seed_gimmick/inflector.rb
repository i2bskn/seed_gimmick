module SeedGimmick
  class Inflector
    attr_reader :seed_dir

    class << self
      def build(options = nil)
        new(options || Options.new)
      end

      # Convert String to model class.
      # @param name [String]
      def model_class(name)
        name.try(:safe_constantize)
      end

      # Convert String to Pathname.
      # @return [Pathname]
      # @return [nil]
      def pathname(path)
        case path
        when Pathname then path
        when String then Pathname.new(path)
        else nil
        end
      end

      # Path without extension.
      # @return [Pathname]
      def without_ext(path)
        pathname(path).dirname.join(pathname(path).basename(".*"))
      end

      # Extension type.
      # @return [Symbol]
      def ext_type(path)
        pathname(path).extname.sub(/\A./, '').to_sym
      end
    end

    def initialize(options)
      @seed_dir = pathname(options.seed_dir)
    end

    # Convert seed file path to model class.
    # @param seed_file [Pathname]
    # @return [ActiveRecord::Base]
    def model_for(seed_file)
      name = from_seed_dir(self.class.without_ext(seed_file)).to_s.classify
      self.class.model_class(name)
    end

    # Convert model class to seed file path.
    # @param model [ActiveRecord::Base]
    # @param format [Symbol] Extension type.
    # @return [Pathname]
    def seed_for(model, format = :yml)
      seed_dir.join(pathname(model.model_name.collection).sub_ext(".#{format}"))
    end

    private
      # Convert lerative path from seed_dir.
      def from_seed_dir(path)
        path = pathname(path)
        path.relative? ? path : path.relative_path_from(seed_dir)
      end

      def pathname(path)
        self.class.pathname(path)
      end
  end
end

