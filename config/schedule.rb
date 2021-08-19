# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# очистить cron -> crontab -r
# просмотр cron -> crontab -l
# сохранение и запуск cron в режиме девелопмент (писать в терминале) ->  whenever --set environment='development' --write-crontab или
# RAILS_ENV=development whenever --write-crontab
# RAILS_ENV=production whenever --write-crontab
# очистить cron - bundle exec whenever --clear-crontab
# сервер минус 3 часов (лето) и минус 4 (зима)

# env :PATH, ENV['PATH']
# env "GEM_HOME", ENV["GEM_HOME"]
# set :output, "#{path}/log/cron.log"
# set :output, "/log/cron.log"
# set :chronic_options, :hours24 => true

every 1.day, :at => '20:15' do
  runner "ProductImportInsalesXmlJob.perform_later"
end

every 1.day, :at => '20:20' do
  runner "TeplomarketJob.perform_later"
end

every 1.day, :at => '08:10' do
  runner "wellfitJob.perform_later"
end

every 1.day, :at => '07:30' do
  runner "DantexgroupJob.perform_later"
end
# ------------------------------
every 1.day, :at => '20:25' do
  runner "ContactJob.perform_later"
end

every 1.day, :at => '20:40' do
  runner "TeplodarJob.perform_later"
end

every 1.day, :at => '20:50' do
  runner "SaunaruJob.perform_later"
end

every 1.day, :at => '22:10' do
  runner "SawoJob.perform_later"
end

every 1.day, :at => '22:35' do
  runner "DimJob.perform_later"
end

every 1.day, :at => '22:50' do
  runner "RealflameJob.perform_later"
end

every 1.day, :at => '23:30' do
  runner "ShulepovJob.perform_later"
end

every 1.day, :at => '02:40' do
  runner "TmfJob.perform_later"
end

every 1.day, :at => '04:30' do
  runner "NkaminJob.perform_later"
end

every 1.day, :at => '06:30' do
  runner "KovchegJob.perform_later"
end

every 1.day, :at => '07:30' do
  runner "LitKomJob.perform_later"
end


every 1.day, :at => '08:30' do
  runner "SyncronaizeJob.perform_later"
end
every 1.day, :at => '08:45' do
  runner "ExportCsvJob.perform_later"
end

