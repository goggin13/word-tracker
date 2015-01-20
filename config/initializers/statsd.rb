if Rails.env.production?
  require 'nunes' 
  require 'statsd'

  STATSD = Statsd.new(ENV["STATSD_PORT_8125_UDP_ADDR"], ENV["STATSD_PORT_8125_UDP_PORT"])
  Nunes.subscribe(STATSD)
end
