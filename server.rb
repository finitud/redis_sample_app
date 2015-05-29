require 'sinatra'
require 'redis'
require 'cf-app-utils'

get "/" do
  settings.redis.keys('*')
end

get "/:key/:value" do |key, value|
  settings.redis.set(key, value)
end

configure do
  redis_credentials = CF::App::Credentials.find_by_service_name('redislabs')
  $stderr.puts "These are our credentials: #{redis_credentials}"
  settings.set :redis, Redis.new(host: redis_credentials['hostname'],
                        port: redis_credentials['port'],
                        password: redis_credentials['password'])
  $stderr.puts "Do we have a redis? #{settings.redis}"
end
