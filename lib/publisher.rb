require 'fetcher'
require 'bunny'

class Publisher
  def self.publish
    setup_bunny_exchange.publish(response.to_json, persistent: true)
  end

  def self.response
    Fetcher.fetch_currencies.slice(:uuid, :rates)
  end

  def self.init_bunny_connection
    Bunny.new
  end

  def self.start_bunny_connection
    init_bunny_connection.start
  end

  def self.create_bunny_channel
    start_bunny_connection.create_channel
  end

  def self.setup_bunny_exchange
    create_bunny_channel.fanout('currencies.fanout')
  end
end
