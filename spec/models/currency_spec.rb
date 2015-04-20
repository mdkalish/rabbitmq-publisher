require 'rails_helper'

describe Currency do
  let(:currency) { Currency.new }

  it 'is valid' do
    expect(currency).to be_valid
  end

  it 'assigns uuid before validation' do
    expect(currency.uuid).to be_nil
    currency.valid?
    expect(currency.uuid).not_to be_nil
  end

  it 'assigns unique uuid before validation' do
    currency.valid?
    currency2 = Currency.new(uuid: currency.uuid)
    expect(currency2.uuid).to eq(currency.uuid)
    currency2.valid?
    expect(currency2.uuid).not_to eq(currency.uuid)
  end

end
