require_relative 'index'

stampery = Stampery.new('2d4cdee7-38b0-4a66-da87-c1ab05b43768', 'prod')

stampery.on :proof do |hash, proof|
    puts("\nReceived proof for \n#{hash} \n\n Proof\n#{proof}");
end

stampery.on :error do |err|
    puts "Woot: #{err}"
end

stampery.on :ready do
    digest = stampery.hash("Hello, blockchain!")
    stampery.stamp(digest)
end

stampery.start()
