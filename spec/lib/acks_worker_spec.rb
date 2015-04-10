require 'rails_helper'
require 'acks_worker'

describe AcksWorker do
  let(:worker) { AcksWorker.new }

  context 'when uuid is found' do
    let(:message) { {id: 1, uuid: Currency.last.uuid} }
    let(:uuid) { message[:uuid] }
    before { Currency.create! }

    it 'sets consumer acknowledgement to true' do
      expect { worker.work(message) } .to change { Currency.last.consumer_1 } .from(nil).to(true)
    end

    it 'returns acknowledgement' do
      expect(worker.work(message)).to eq(:ack)
    end
  end

  context 'when uuid is not found' do
    before { 4.times { worker.work(id: 1, uuid: 'invalid') } }
    after { Rails.cache.clear('try_count') }

    it 'requeues up to 5 times' do
      expect(worker.work(id: 1, uuid: 'invalid')).to eq(:requeue)
    end

    it 'rejects the query after 5 requeues' do
      worker.work(id: 1, uuid: 'invalid')
      expect(worker.work(id: 1, uuid: 'invalid')).to eq(:reject)
    end
  end
end
