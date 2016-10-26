require 'stampery/version'
require 'bunny'
require 'digest/md5'
require 'sha3'
require 'msgpack/rpc'
require 'event_emitter'
require 'rubygems'

class Client
  include EventEmitter
  @@api_end_points = { 'prod' => ['api.stampery.com', 4000],
                       'beta' => ['api-beta.stampery.com', 4000] }
  @@amqp_end_points = { 'prod' => ['young-squirrel.rmq.cloudamqp.com', 5672, 'consumer', '9FBln3UxOgwgLZtYvResNXE7', 'ukgmnhoi'],
                        'beta' => ['young-squirrel.rmq.cloudamqp.com', 5672, 'consumer', '9FBln3UxOgwgLZtYvResNXE7', 'beta'] }

  def initialize secret, branch = 'prod'
    @client_secret = secret
    @client_id = Digest::MD5.hexdigest(secret)[0, 15]
    @api_end_point = @@api_end_points[branch] || @@api_end_points['prod']
    @amqp_end_point = @@amqp_end_points[branch] || @@amqp_end_points['prod']
  end

  def start
    api_login @api_end_point
    amqp_login @amqp_end_point
  end

  def stamp data
    puts "Stamping \n#{data}"
    begin
      @api_client.call 'stamp', data.upcase
    rescue Exception => e
      emit :error, e
    end
  end

  def hash data
    SHA3::Digest.hexdigest(:sha512, data).upcase
  end

  private

  def api_login end_point
    @api_client = MessagePack::RPC::Client.new(end_point[0], end_point[1])
    user_agent = "ruby-#{Gem::Specification::load("stampery.gemspec").version}"
    req = @api_client.call_async('stampery.3.auth', @client_id, @client_secret, user_agent)
    req.join
    @auth = req.result
    puts "logged #{@client_id}"
  end

  def amqp_login end_point
    amqp_conn = Bunny.new(automatically_recover: true, host: end_point[0],
                          port: end_point[1], user: end_point[2],
                          pass: end_point[3], vhost: end_point[4])
    amqp_conn.start
    puts '[QUEUE] Connected to Rabbit!'
    emit :ready

    amqp_channel = amqp_conn.create_channel

    queue = amqp_channel.queue(@client_id + '-clnt', no_declare: true)
    begin
      queue.subscribe(block: true) do |delivery_info, _metadata, queueMsg|
        hash = delivery_info.routing_key
        proof = MessagePack.unpack queueMsg
        emit :proof, hash, proof
      end
    rescue Exception => _
      puts "\n\nClosing the client"
    end
  end
end
