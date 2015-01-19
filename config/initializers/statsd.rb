if Rails.env.production?
  require 'nunes'

  STATSD = Statsd.new('localhost', 8125)
  Nunes.subscribe(STATSD)
end
