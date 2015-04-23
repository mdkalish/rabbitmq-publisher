require 'uri'
require 'net/http'
require 'json'

class Fetcher
  extend ActiveSupport::Concern

  BASE_URL = 'http://openexchangerates.org/api'
  APP_ID = ENV['open_exchange_rates_app_id']

  def self.fetch_currencies
    if Currency.any? && Currency.last.created_at > 1.hour.ago
      Currency.last
    else
      Currency.create!(rates: Fetcher.parsed_body['rates'])
    end
  end

  private

  def self.uri
    URI.parse("#{BASE_URL}/latest.json?app_id=#{APP_ID}")
  end

  def self.get_response_body
    Net::HTTP.get_response(uri).body
  end

  def self.parsed_body
    JSON.parse(get_response_body)
  end
end

