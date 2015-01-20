module SeedGimmick
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "tasks/seed_gimmick.rake"
    end
  end
end

