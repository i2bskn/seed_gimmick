module SeedGimmick
  class Options
    %i(seed_dir).each do |key|
      define_method "#{key}=" do |value|
        @options[key] = value
      end
    end

    def initialize(options = {})
      @options = options.symbolize_keys
    end

    def seed_dir
      @options[:seed_dir] || default_seed_dir
    end

    private
      def default_seed_dir
        (defined?(Rails) ? Rails.root : Pathname.pwd).join("db", "seeds")
      end
  end
end

