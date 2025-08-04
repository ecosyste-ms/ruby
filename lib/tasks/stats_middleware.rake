namespace :stats_middleware do
  desc "Show summary statistics"
  task summary: :environment do
    reporter = Stats::Middleware::StatsReporter.new(redis: Redis.new)
    reporter.display_summary(days: 7, limit: 10)
  end

  desc "Show detailed summary statistics"
  task detailed_summary: :environment do
    reporter = Stats::Middleware::StatsReporter.new(redis: Redis.new)
    reporter.display_summary(days: 30, limit: 50)
  end

  desc "Export statistics to JSON file"
  task :export, [:days, :filename] => :environment do |t, args|
    days = args[:days]&.to_i || 30
    filename = args[:filename] || 'stats_export.json'
    
    reporter = Stats::Middleware::StatsReporter.new(redis: Redis.new)
    stats = reporter.summary(days: days)
    
    File.write(filename, JSON.pretty_generate(stats))
    puts "Exported #{days} days of stats to #{filename}"
  end
end