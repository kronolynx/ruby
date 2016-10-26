require 'stampery'

# Sign up and get your secret token at https://api-dashboard.stampery.com
stampery = Client.new 'user-secret'

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
