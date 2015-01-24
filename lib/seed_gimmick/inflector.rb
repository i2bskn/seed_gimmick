module SeedGimmick
  class Inflector
    attr_reader :seed_dir

    class << self
      def build(options = nil)
        new(options || Options.new)
      end

      def model_class(name)
        name.try(:safe_constantize)
      end

      def pathname(path)
        case path
        when Pathname then path
        when String then Pathname.new(path)
        else nil
        end
      end
    end

    def initialize(options)
      @seed_dir = options.seed_dir
    end

    def model_for(seed_file)
      class_name = relative_path(without_ext(seed_file)).to_s.classify
      self.class.model_class(class_name)
    end

    def seed_for(model, format = :yml)
      seed_dir + pathname(model.model_name.collection).sub_ext(".#{format}")
    end

    private
      def without_ext(path)
        path.dirname + path.basename(".*")
      end

      def relative_path(path)
        path.relative? ? path : path.relative_path_from(seed_dir)
      end

      def pathname(path)
        self.class.pathname(path)
      end
  end
end

