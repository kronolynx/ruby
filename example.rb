require_relative 'index'

stampery = Stampery.new('367c6ec2-5791-4cf5-8094-4bae00c639b4', 'prod')

stampery.on :proof do |hash, proof|
    puts("Received proof for #{hash}");
    puts proof.inspect
    stampery.prove(hash, proof)
end

stampery.on :error do |err|
    puts "Woot: #{err}"
end

stampery.on :ready do
    digest = stampery.hash("Hello, blockchain!")
    res = stampery.stamp(digest)
end

stampery.start()
