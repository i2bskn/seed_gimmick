module SeedGimmick
  class Options
    VALID_OPTIONS_KEYS = %i(
      seed_dir
      tables
      default_ext
      exclude_columns
    ).freeze

    VALID_OPTIONS_KEYS.each do |key|
      define_method "#{key}=" do |value|
        @options[key] = value
      end
    end

    def initialize(options = {})
      @options = options.symbolize_keys
    end

    def seed_dir
      root_dir.join(@options[:seed_dir] || default_seed_dir)
    end

    def tables
      @options[:tables] || ENV["TABLES"].try(:split, ",") || []
    end

    def tables!
      tables.presence || (raise SeedGimmickError)
    end

    def default_ext
      @options[:default_ext] || ENV["FORMAT"] || "json"
    end

    def exclude_columns
      @options[:exclude_columns] ||= default_exclude_columns
    end

    def environment
      ENV["RAILS_ENV"] || ENV["APP_ENV"] || default_env
    end

    private

      def default_seed_dir
        root_dir.join("db", "seeds")
      end

      def default_exclude_columns
        ["created_at", "updated_at"]
      end

      def default_env
        defined?(Rails) ? Rails.env : "development".inquiry
      end

      def root_dir
        defined?(Rails) ? Rails.root : Pathname.pwd
      end
  end
end
