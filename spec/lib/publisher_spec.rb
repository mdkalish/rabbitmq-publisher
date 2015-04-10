require 'support/bunny_mock'

describe Publisher do
  let(:response) { JSON.parse(File.read(Rails.root.join('spec/fixtures/response.json'))) }
  let(:bunny_session) { BunnyMock.new }
  let(:channel) { spy('channel') }

  before do
    allow(Fetcher).to receive(:fetch_currencies).and_return(response)
    allow(Bunny).to receive(:new).and_return(bunny_session)

    allow_message_expectations_on_nil
    allow(Publisher).to receive(:create_bunny_channel).and_return(channel)
    allow(Publisher.setup_bunny_exchange).to receive(:publish)
  end

  it 'initializes bunny session' do
    expect(Publisher.init_bunny_connection).to be(bunny_session)
  end

  it 'starts bunny session' do
    expect(Publisher.start_bunny_connection).to be(bunny_session.start)
  end

  it 'creates bunny channel' do
    expect(Publisher).to receive(:create_bunny_channel).and_return(channel)
    Publisher.publish
  end

  it 'calls bunny fanout on channel' do
    expect(channel).to have_received(:fanout).with('currencies.fanout')
  end

  it 'returns correct response' do
    expect(Publisher.response).to eq(response.slice(:uuid, :rates))
  end

  it 'publishes the response' do
    expect(Publisher.setup_bunny_exchange).to receive(:publish)
    Publisher.publish
  end
end
