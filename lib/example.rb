require 'stampery'

stampery = Client.new '2d4cdee7-38b0-4a66-da87-c1ab05b43768', 'prod'

stampery.on :proof do |hash, proof|
  puts 'Received proof for'
  puts hash
  puts 'Proof'
  puts proof.to_s
end

stampery.on :error do |err|
  puts "Woot: #{err}"
end

stampery.on :ready do
  digest = stampery.hash 'Hello, blockchain!'
  stampery.stamp digest
end

stampery.start
