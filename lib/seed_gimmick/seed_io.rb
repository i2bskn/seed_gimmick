require "seed_gimmick/seed_io/base"
require "seed_gimmick/seed_io/yaml_file"

module SeedGimmick
  module SeedIO
    def self.get(seed_file)
      ext = File.extname(seed_file.to_s).presence || (raise SeedGimmickError)
      ext.sub!(/\A\./, "")
      ext = "yaml" if ext == "yml"
      const_get("#{ext.capitalize}File", false).new(seed_file)
    end
  end
end

