module SeedGimmick
  class Inflector
    attr_reader :seed_dir

    def initialize(seed_dir)
      @seed_dir = seed_dir
    end

    def model_for(seed_file)
      relative_path(without_ext(seed_file)).to_s.classify.constantize
    end

    def seed_for(model, format = :yml)
      seed_dir + _pathname(model.model_name.collection).sub_ext(".#{format}")
    end

    private
      def without_ext(pathname)
        pathname.dirname + pathname.basename(".*")
      end

      def relative_path(pathname)
        pathname.relative? ? pathname : pathname.relative_path_from(seed_dir)
      end

      def _pathname(path)
        case path
        when Pathname then path
        when String then Pathname.new(path)
        else nil
        end
      end
  end
end

