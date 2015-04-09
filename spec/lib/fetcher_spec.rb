require 'rails_helper'
require 'fetcher'

describe Fetcher do
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
      Currency.create!(created_at: 3601.seconds.ago)
      expect { Fetcher.fetch_currencies } .to change { Currency.count } .from(1).to(2)
    end
  end
end
