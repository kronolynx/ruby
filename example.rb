require 'stampery'

# Sign up and get your secret token at https://api-dashboard.stampery.com
stampery = Client.new 'user-secret'

stampery.on :proof do |hash, proof|
  puts "Received proof for \n#{hash}\n\n"
  puts 'Proof'
  puts "Version: #{proof['version']}\nSiblings: #{proof['siblings']}\nRoot: #{proof['root']}"
  puts "Anchor:\n  Chain: #{proof['anchor']['chain']}\n  Tx: #{proof['anchor']['tx']}\n"
end

stampery.on :error do |err|
  puts "Woot: #{err}"
end

stampery.on :ready do
  digest = stampery.hash 'Hello, blockchain!'
  stampery.stamp digest
end

stampery.start
