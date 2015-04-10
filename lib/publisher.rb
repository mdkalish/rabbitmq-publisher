require 'fetcher'
require 'bunny'

class Publisher
  def self.publish
    exchange.publish(response.to_json, persistent: true)
  end

  private

  def self.response
    Fetcher.fetch_currencies.slice(:uuid, :rates)
  end

  def self.connection
    @connection ||= Bunny.new.tap { |c| c.start }
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.exchange
    channel.fanout('currencies.fanout')
  end
end
