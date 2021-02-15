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
# set :chronic_options, :hours24 => true
#
every 1.day, :at => '03:00' do
  runner "Mb.import_linking_syncronaize"
end

every 1.day, :at => '04:00' do
  runner "Mb.unlinking_to_csv"
end
#
# every 1.day, :at => '16:00' do
#   runner "Product.import"
# end
