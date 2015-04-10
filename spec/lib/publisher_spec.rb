describe Publisher do
  let(:response) { JSON.parse(File.read(Rails.root.join('spec/fixtures/response.json'))) }
  before { allow(Fetcher).to receive(:fetch_currencies).and_return(response) }

  it 'returns Bunny::Exchange' do
    expect(Publisher.publish.class).to eq(Bunny::Exchange)
  end

  it 'responds with uuid and rates' do
    expect(Publisher.response).to eq(response.slice(:uuid, :rates))
  end
end
