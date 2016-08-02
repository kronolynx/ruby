require "bunny"
require 'digest/md5'
require 'sha3'
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
    end

    def start
    end

    def stamp
    end

    def hash data
        SHA3::Digest.hexdigest(:sha224, data).upcase
    end

    private
    def apiLogin endpoint

    end

    def amqpLogin endpoint

    end
end
