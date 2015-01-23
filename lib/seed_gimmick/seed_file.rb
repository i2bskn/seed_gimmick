module SeedGimmick
  class SeedFile
    attr_reader :inflector, :seed_file

    EXCLUDE_COLUMNS = ["created_at", "updated_at"].freeze

    class << self
      def find(options = nil)
        options ||= Options.new
        seed_files(options.seed_dir).map {|file|
          SeedFile.new(options.seed_dir, file)
        }.select {|seed|
          options.tables.empty? || options.tables.include?(seed.table_name)
        }
      end

      private
        def seed_files(seed_dir)
          Pathname.glob(seed_dir.join("**", "*")).select(&:file?)
        end
    end

    def initialize(seed_dir, seed_file)
      @inflector = Inflector.build(seed_dir)
      @seed_file = seed_file
    end

    def load_file
      SeedIO.get(seed_file).load_data
    end

    def write_file(array_of_hashes)
      SeedIO.get(seed_file).dump_data(array_of_hashes)
    end

    def table_name
      model.model_name.plural
    end

    def model
      @_model ||= inflector.model_for(seed_file)
    end

    def bootstrap
      ActiveRecord::Migration.say_with_time(table_name) do
        model.transaction do
          model.delete_all
          model.import(data.map {|rec| _model.new(rec) })
        end
      end
    rescue LoadFailed => e
      $stdout.print e.message
    end

    def dump
      columns = model.column_names.select {|column_name|
        !SeedFile::EXCLUDE_COLUMNS.include?(column_name)
      }

      write_file(model.select(*columns).map(&:attributes))
    end
  end
end

