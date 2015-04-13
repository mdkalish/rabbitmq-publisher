require 'rails_helper'
require 'acks_worker'

describe AcksWorker do
  let(:worker) { AcksWorker.new }

  context 'when uuid is found' do
    let(:message) { {id: 1, uuid: Currency.last.uuid}.to_json }
    let(:uuid) { message['uuid'] }
    before { Currency.create! }

    it 'sets consumer acknowledgement to true' do
      expect { worker.work(message) } .to change { Currency.last.consumer_1 } .from(nil).to(true)
    end

    it 'returns acknowledgement' do
      expect(worker.work(message)).to eq(:ack)
    end
  end

  context 'when uuid is not found' do
    let(:invalid_message) { {id: 1, uuid: 'invalid'}.to_json }
    before { 4.times { worker.work(invalid_message) } }
    after { Rails.cache.clear('try_count') }

    it 'requeues up to 5 times' do
      expect(worker.work(invalid_message)).to eq(:requeue)
    end

    it 'rejects the query after 5 requeues' do
      worker.work(invalid_message)
      expect(worker.work(invalid_message)).to eq(:reject)
    end
  end
end
