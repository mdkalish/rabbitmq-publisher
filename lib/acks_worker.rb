class AcksWorker
  include Sneakers::Worker
  from_queue 'currencies.acknowledgements', durable: true

  def work(message)
    msg = JSON.parse(message)
    if currency = Currency.find_by(uuid: msg['uuid'])
      currency.update_attribute("consumer_#{msg['id']}", true)
      ack!
    elsif try_count <= 5
      requeue!
    else
      Rails.cache.clear('try_count')
      reject!
    end
  end

  def try_count
    if Rails.cache.read('try_count').blank?
      Rails.cache.write('try_count', 1)
      1
    else
      Rails.cache.increment('try_count')
    end
  end
end
