class AcksWorker
  include Sneakers::Worker
  from_queue 'currencies.acknowledgements', durable: true

  def work(message)
    msg = JSON.parse(message)
    if currency = Currency.find_by(uuid: msg['uuid'])
      currency.update_attribute("consumer_#{msg['id']}", true)
      ack!
    else
      reject!
    end
  end
end
