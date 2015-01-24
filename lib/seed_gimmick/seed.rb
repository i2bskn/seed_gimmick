module SeedGimmick
  class Seed
    class << self
      def find(options = nil)
        options ||= Options.new
        seed_files(options).map {|file|
          new(file, options)
        }.select {|seed|
          options.tables.empty? || options.tables.include?(seed.table_name)
        }
      end

      private
        def seed_files(options)
          Pathname.glob(options.seed_dir.join("**", "*")).select(&:file?)
        end
    end

    def initialize(file_or_model, options = nil)
      @options = options || Options.new
      @inflector = Inflector.build(@options)
      unless @model = Inflector.model_class(file_or_model)
        @seed_file = Inflector.pathname(file_or_model)
      end
      self_validation!
    end

    def model
      self_validation!
      @model ||= @inflector.model_for(@seed_file)
    end

    def seed_file(ext = nil)
      self_validation!
      @seed_file ||= @inflector.seed_for(@model, (ext || @options.default_ext))
    end

    def table_name
      model.model_name.plural
    end

    def dump_columns(exclude_columns = [], all = false)
      return model.column_names if all
      exclude_columns = exclude_columns.presence || @options.exclude_columns
      model.column_names - exclude_columns
    end

    def load_file
      SeedIO.get(seed_file).load_data
    end

    def write_file(array_of_hashes)
      SeedIO.get(seed_file).dump_data(array_of_hashes)
    end

    def bootstrap
      ActiveRecord::Migration.say_with_time(table_name) do
        model.transaction do
          model.delete_all
          model.import(load_file.map {|hash| model.new(hash) })
        end
      end
    rescue LoadFailed => e
      $stdout.print e.message
    end

    def dump(exclude_columns = [])
      write_file(model.select(*dump_columns(exclude_columns)).map(&:attributes))
    end

    private
      def self_validation!
        @model || @seed_file || (raise SeedGimmickError)
      end
  end
end

