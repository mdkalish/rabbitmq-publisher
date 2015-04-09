require 'rails_helper'
require 'fetcher'
require 'active_support/testing/time_helpers'

describe Fetcher do
  include ActiveSupport::Testing::TimeHelpers
  let(:rates) { File.read(Rails.root.join('spec/fixtures/response.json')) }
  before { allow(Fetcher).to receive(:get_response_body).and_return(rates) }

  it 'fetches rates when db is empty' do
    expect(Currency.any?).to be_falsy
    Fetcher.fetch_currencies
    expect(Currency.count).to eq(1)
  end

  context 'when last fetch was less than one hour ago' do
    it 'returns rates from the last fetch' do
      initial_fetch = Fetcher.fetch_currencies
      expect(Currency.last.created_at > 1.hour.ago).to be_truthy
      expect(Fetcher.fetch_currencies).to eq(initial_fetch)
    end
  end

  context 'when last fetch was more than one hour ago' do
    it 'fetches new rates' do
      first_record = Currency.create!(created_at: 3601.seconds.ago)
      other_record = Fetcher.fetch_currencies
      expect(first_record.uuid).not_to eq(other_record.uuid)
    end

    it 'stores newly fetched rates in db' do
      Fetcher.fetch_currencies
      expect(Currency.count).to eq(1)
      travel_to 1.hour.from_now + 1.second
      Fetcher.fetch_currencies
      expect(Currency.count).to eq(2)
      travel_back
    end
  end
end
