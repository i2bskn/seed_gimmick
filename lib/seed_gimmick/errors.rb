module SeedGimmick
  class SeedGimmickError < StandardError; end

  class LoadFailed < SeedGimmickError
    def initialize(seed_file)
      super("Can not load: #{seed_file.to_s}")
    end
  end
end

