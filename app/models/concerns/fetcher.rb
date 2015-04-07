require 'uri'
require 'net/http'
require 'json'

module Fetcher
  extend ActiveSupport::Concern

  BASE_URL = 'http://openexchangerates.org/api'
  APP_ID = ENV['open_exchange_rates_app_id']

  def self.fetch_currencies
    if Currency.any? && Currency.last.created_at > 1.hour.ago
      Currency.last.rates
    else
      rb = Fetcher.response_body
      timestamp = DateTime.strptime(rb['timestamp'].to_s, '%s')
      Currency.create!(rates: rb['rates'], created_at: timestamp)
    end
  end

  private

  def self.uri(endpoint = '/latest.json')
    URI.parse("#{BASE_URL}#{endpoint}?app_id=#{APP_ID}")
  end

  def self.get_response
    Net::HTTP.get_response(uri)
  end

  def self.response_body
    JSON.parse(get_response.body)
  end
end
