require "bunny"
require 'digest/md5'
require 'sha3'
require 'msgpack/rpc'
require "event_emitter"


class Stampery
    include EventEmitter
    @@apiEndpoints = {'prod' => ['192.168.1.52', 4000],
                     'beta' => ['api-beta.stampery.com', 4000]}
    @@amqpEndpoints = {'prod' => ['young-squirrel.rmq.cloudamqp.com', 5672, 'consumer', '9FBln3UxOgwgLZtYvResNXE7', 'ukgmnhoi'],
                      'beta' => ['young-squirrel.rmq.cloudamqp.com', 5672, 'consumer', '9FBln3UxOgwgLZtYvResNXE7', 'beta']}

    def initialize(secret, branch = 'prod')
        @clientSecret = secret
        @clientId = Digest::MD5.hexdigest(secret)[0,15]
        @apiEndpoint = @@apiEndpoints[branch] || @@apiEndpoints['prod']
        @amqpEndpoint = @@amqpEndpoints[branch] || @@amqpEndpoints['prod']
    end

    def start
        apiLogin @apiEndpoint
        amqpLogin @amqpEndpoint
    end

    def stamp hash
        puts "Stamping \n#{hash}"
        begin
            @apiClient.call('stamp', hash.upcase)
        rescue Exception => e
            emit :error, e
        end
    end

    def hash data
        SHA3::Digest.hexdigest(:sha512, data).upcase
    end

    private
    def apiLogin endpoint
        @apiClient = MessagePack::RPC::Client.new(endpoint[0], endpoint[1])
        req = @apiClient.call_async('stampery.3.auth', @clientId, @clientSecret)
        req.join
        @auth = req.result
        puts "logged #{@clientId} Auth #{@auth}"
    end

    def amqpLogin endpoint
        amqpConn = Bunny.new(:automatically_recover => true, :host => endpoint[0], :port => endpoint[1], :user => endpoint[2], :pass => endpoint[3], :vhost => endpoint[4] )
        amqpConn.start
        puts '[QUEUE] Connected to Rabbit!'
        emit :ready

        amqpChannel = amqpConn.create_channel

        queue = amqpChannel.queue(@clientId + '-clnt', :no_declare => true)
        begin
            queue.subscribe(:block => true) do |delivery_info, _metadata, queueMsg|
                hash = delivery_info.routing_key
                proof = MessagePack.unpack queueMsg
                emit :proof ,hash ,proof
            end
        rescue Exception => _
            puts "\n\nClosing the client"
        end
        #
    end
end
