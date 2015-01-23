namespace :db do
  task :seed_gimmick => :environment do
    SeedGimmick.bootstrap
  end

  namespace :seed_gimmick do
    task :dump => :environment do
      SeedGimmick.dump
    end
  end
end

