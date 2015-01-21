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
require "seed_gimmick/seed_file"
require "seed_gimmick/railtie" if defined?(Rails)

module SeedGimmick
  def self.bootstrap!(options = nil)
    SeedFile.find(options).each do |seed|
      seed.bootstrap!
    end
  end

  def self.seed_from(path)
    path = Pathname.new(path.to_s) unless path.is_a?(Pathname)
    options = Options.new(seed_dir: path)
    bootstrap!(options)
  end
end

