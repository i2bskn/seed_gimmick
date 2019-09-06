require "yaml"
require "csv"
require "pathname"

require "active_support"
require "active_record"

require "seed_gimmick/version"
require "seed_gimmick/errors"
require "seed_gimmick/options"
require "seed_gimmick/inflector"
require "seed_gimmick/seed_io"
require "seed_gimmick/seed"

module SeedGimmick
  class << self
    def bootstrap(options = nil)
      SeedGimmick::Seed.find(options).each(&:bootstrap)
    end
  end
end
