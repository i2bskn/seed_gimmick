require "yaml"
require "csv"
require "pathname"

require "active_support"
require "active_record"
require "activerecord-import"

require "seed_gimmick/version"
require "seed_gimmick/errors"
require "seed_gimmick/options"
require "seed_gimmick/inflector"
require "seed_gimmick/seed_io"
require "seed_gimmick/seed"
require "seed_gimmick/railtie" if defined?(Rails)

module SeedGimmick
  class << self
    def bootstrap(options = nil)
      Seed.find(options).each {|seed| seed.bootstrap }
    end

    def dump(options = nil)
      options ||= Options.new
      options.models.each do |model_name|
        Seed.new(model_name, options).dump
      end
    end
  end
end

