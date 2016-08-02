require "bunny"
require 'digest/md5'
#require 'msgpack'
require 'msgpack/rpc'
require "event_emitter"


class Stampery
    include EventEmitter
    @apiEndpoints = {'prod' => ['api.stampery.com', 4000],
                     'beta' => ['api-beta.stampery.com', 4000]}
    @amqpEndpoints = {'prod' => ['young-squirrel.rmq.cloudamqp.com', 5672, 'consumer', '9FBln3UxOgwgLZtYvResNXE7', 'ukgmnhoi'],
                      'beta' => ['young-squirrel.rmq.cloudamqp.com', 5672, 'consumer', '9FBln3UxOgwgLZtYvResNXE7', 'beta']}

    def initialize(secret, branch = 'prod')
        @clientId = Digest::MD5.hexdigest(secret[0,15])
        puts @clientId
    end

    private
    def apiLogin(endpoint)
        @apiClient = new Client(endpoint[0], endpoint[1])
        @auth = @apiClient.call('stampery.3.auth', [@clientId, @clientSecret])
    end

    def amqpLogin(endpoint)

    end
end
