module SeedGimmick
  class Options
    VALID_OPTIONS_KEYS = %i(
    seed_dir
    tables
    models
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
      @options[:seed_dir] || default_seed_dir
    end

    def tables
      @options[:tables] || ENV["TABLES"].try(:split, ",") || []
    end

    def tables!
      tables.presence || (raise SeedGimmickError)
    end

    def models
      @options[:models] || ENV["MODELS"].try(:split, ",") || []
    end

    def models!
      models.presence || (raise SeedGimmickError)
    end

    def default_ext
      @options[:default_ext] || ENV["FORMAT"] || :yml
    end

    def exclude_columns
      @options[:exclude_columns] || default_exclude_columns
    end

    private
      def default_seed_dir
        (defined?(Rails) ? Rails.root : Pathname.pwd).join("db", "seed_gimmick")
      end

      def default_exclude_columns
        ["created_at", "updated_at"]
      end
  end
end

