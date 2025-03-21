require 'csv'

namespace :projects do
  desc 'sync projects'
  task :sync => :environment do
    Project.sync_least_recently_synced
  end
  desc 'import projects'
  task :import => :environment do
    Project.import
  end

  desc 'discover projects'
  task :discover => :environment do
    Project.discover_via_topics
    Project.discover_via_keywords
  end

  desc 'sync dependencies'
  task :sync_dependencies => :environment do
    Project.sync_dependencies
  end
end