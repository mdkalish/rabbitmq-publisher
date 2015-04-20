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

    it 'sends reject' do
      expect(worker.work(invalid_message)).to eq(:reject)
    end
  end
end
