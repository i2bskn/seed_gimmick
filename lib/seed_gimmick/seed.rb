require "seed_gimmick/seed/difference"

module SeedGimmick
  class Seed
    class << self
      def find(options = nil)
        options ||= Options.new
        seed_files(options).map { |file|
          new(file, options)
        }.select { |seed|
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
      @model = Inflector.model_class(file_or_model)
      @seed_file = Inflector.pathname(file_or_model) unless @model
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

    def seed_io
      @seed_io ||= SeedIO.factory(seed_file)
    end

    def table_name
      model.model_name.plural
    end

    def dump_columns(exclude_columns = [], all = false)
      return model.column_names if all

      exclude_columns = exclude_columns.presence || @options.exclude_columns
      model.column_names - exclude_columns
    end

    def bootstrap
      ActiveRecord::Migration.say_with_time(table_name) do
        model.transaction do
          model.delete_all
          model.import(seed_io.values.map { |hash| model.new(hash) })
        end
        seed_io.values.size
      end
    rescue LoadFailed => e
      $stdout.print e.message
    end

    def dump(exclude_columns = [])
      ActiveRecord::Migration.say_with_time(table_name) do
        seed_io.dump_data(model.select(*dump_columns(exclude_columns)).map(&:attributes))
      end
    end

    def compare
      Difference.extraction(self)
    end

    private

      def self_validation!
        @model || @seed_file || (raise SeedGimmickError)
      end
  end
end
