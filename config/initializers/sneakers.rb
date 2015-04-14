require 'sneakers/handlers/maxretry'

Sneakers.configure(
  :heartbeat => 100,
  :handler => Sneakers::Handlers::Maxretry,
  :retry_timeout => 30_000,
  :exchange => '',
  :routing_key => [],
  :workers => 1,
  :threads => 1,
  :prefetch => 1
)

Sneakers.logger.level = Logger::INFO
