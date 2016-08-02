require_relative 'index'

stampery = Stampery.new('f7862a3e-174e-4741-f882-60702952d335', 'prod')

# stampery.on :proof do |hash, proof|
#     puts("Received proof for #{hash}");
#     puts proof.inspect
#     stampery.prove(hash, proof)
# end
#
# stampery.on :error do |err|
#     puts "Woot: #{err}"
# end
#
# stampery.on :ready do
#     digest = stampery.hash("Hello, blockchain!")
#     res = stampery.stamp(digest)
# end

stampery.start()
