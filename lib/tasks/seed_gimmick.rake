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

namespace :seed_gimmick do
  require "pp"

  task :config do
    pp SeedGimmick::Options.new.load_config
  end

  task :seed_files do
    pp SeedGimmick::Seed.find.map {|seed| seed.seed_file.to_s }
  end

  task :diff => :environment do
    SeedGimmick::Seed.find.each do |seed|
      ActiveRecord::Migration.say_with_time(seed.table_name) do
        seed.compare.each do |changed|
          puts [changed.flag, changed.id, changed.change_values].join("\t")
        end
      end
    end
  end
end

