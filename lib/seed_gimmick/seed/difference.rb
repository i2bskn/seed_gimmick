module SeedGimmick
  class Seed
    class Difference
      include Enumerable

      attr_reader :changes

      module Flag
        DATABASE = "-"
        SEED = "+"
        CHANGE = "<>"
      end

      class << self
        def extraction(seed)
          pk = seed.model.primary_key
          database = seed.model.all.each_with_object({}) {|row, obj|
            obj[row.public_send(pk)] = row
          }
          seed_data = seed.seed_io.values.each_with_object({}) {|row, obj|
            obj[row[pk].to_i] = row
          }
          diff = []
          (database.keys - seed_data.keys).each do |id|
            diff << [Flag::DATABASE, id, database.delete(id), nil, nil]
          end
          (seed_data.keys - database.keys).each do |id|
            diff << [Flag::SEED, id, nil, seed_data.delete(id), nil]
          end
          database.each do |id, row|
            s_attrs = seed_data[id].dup
            s_attrs.delete(pk)
            row.assign_attributes(s_attrs)
            if row.changed?
              changes = row.changes
              changes.each {|k,(old,_)| row.public_send("#{k}=", old) }
              diff << [Flag::CHANGE, id, row, seed_data.delete(id), changes]
            end
          end
          new(diff)
        end
      end

      def initialize(diff)
        @changes = diff.sort_by(&:second).map {|d| Change.new(*d) }
      end

      def changed?
        !@changes.empty?
      end

      def each
        @changes.each do |change|
          yield change
        end
      end

      class Change < Struct.new(:flag, :id, :database, :seed_data, :changes)
        EXCLUDES = [
          "created_at",
          "updated_at"
        ].freeze

        def change_values
          changes.presence || changes_from_data
        end

        private
          def changes_from_data
            if database
              attrs = database.attributes
              attrs.reject! {|k,_| EXCLUDES.include?(k) } || attrs
            else
              seed_data
            end
          end
      end
    end
  end
end

