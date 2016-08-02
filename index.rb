require "bunny"
require 'digest/md5'
require 'sha3'
#require 'msgpack'
require 'msgpack/rpc'
require "event_emitter"


class Stampery
    include EventEmitter
    @@apiEndpoints = {'prod' => ['api.stampery.com', 4000],
                     'beta' => ['api-beta.stampery.com', 4000]}
    @@amqpEndpoints = {'prod' => ['young-squirrel.rmq.cloudamqp.com', 5672, 'consumer', '9FBln3UxOgwgLZtYvResNXE7', 'ukgmnhoi'],
                      'beta' => ['young-squirrel.rmq.cloudamqp.com', 5672, 'consumer', '9FBln3UxOgwgLZtYvResNXE7', 'beta']}

    def initialize(secret, branch = 'prod')
        @clientSecret = secret
        @clientId = Digest::MD5.hexdigest(secret)[0,15]
        @apiEndpoint = @@apiEndpoints[branch] || @@apiEndpoints['prod']
    end

    def start
        apiLogin @apiEndpoint

    end

    def stamp hash
        puts "Stamping #{hash}"
    end

    def hash data
        SHA3::Digest.hexdigest(:sha224, data).upcase
    end

    private
    def apiLogin endpoint
        apiClient = MessagePack::RPC::Client.new(endpoint[0], endpoint[1])
        req = apiClient.call_async('stampery.3.auth', @clientId, @clientSecret)
        req.join
        @auth = req.result
    end

    def amqpLogin endpoint

    end
end
