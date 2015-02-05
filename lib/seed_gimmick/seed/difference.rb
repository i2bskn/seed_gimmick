module SeedGimmick
  class Seed::Difference
    attr_reader :type, :record, :changes

    class << self
      def extraction(seed)
        pk = seed.model.primary_key
        rows = seed.model.all.group_by {|row| row.public_send(pk) }
        load_file.map {|loaded|
          attrs = loaded.dup
          id = attrs.delete(pk)
          if row = Array(rows.fetch(id, nil)).first
            row.assign_attributes(attrs)
            row.changed? ? data_hash(row) : nil
          else
            data_hash(loaded)
          end
        }.compact.map {|diff| new(diff) }
      end

      private
        def data_hash(row_or_hash)
          type = row_or_hash.is_a?(Hash) ? :new : :exist
          changes = row_or_hash.is_a?(Hash) ? row_or_hash : row_or_hash.changes
          {
            type: type,
            record: type == :exist ? row_or_hash : nil,
            changes: changes
          }
        end
    end

    def initialize(diff)
      @type = diff[:type]
      @record = diff[:record]
      @changes = diff[:changes]
    end
  end
end

