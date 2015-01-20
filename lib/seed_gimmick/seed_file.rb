module SeedGimmick
  class SeedFile
    include Finder

    attr_reader :inflector, :seed_file

    def initialize(seed_dir, seed_file)
      @inflector = Inflector.new(seed_dir)
      @seed_file = seed_file
    end

    def load_file
      SeedIO.get(seed_file).load_data
    end

    def bootstrap!
      custom_action do |model, data|
        ActiveRecord::Migration.say_with_time(model.model_name.plural) do
          model.transaction do
            model.delete_all
            model.import(data.map {|rec| model.new(rec) })
          end
        end
      end
    rescue LoadFailed => e
      puts e.message
    end

    def custom_action
      yield(_model, load_file) if block_given?
    end

    private
      def _model
        @_model ||= inflector.model_for(seed_file)
      end
  end
end

