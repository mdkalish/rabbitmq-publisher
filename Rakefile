# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'Setup rabbitmq communication'
task setup_rabbitmq: :environment do
  require 'bunny'

  connection = Bunny.new
  connection.start
  channel = connection.create_channel

  xchange_in = channel.fanout('currencies.fanout')
  xchange_out = channel.direct('currencies.direct')

  queue_1 = channel.queue('currencies.queue_1', durable: true).bind('currencies.fanout')
  queue_2 = channel.queue('currencies.queue_2', durable: true).bind('currencies.fanout')
  queue_3 = channel.queue('currencies.queue_3', durable: true).bind('currencies.fanout')

  acknowledgements = channel.queue('currencies.acknowledgements', durable: true)
    .bind('currencies.direct', routing_key: 'acknowledgements')

  connection.close
end
