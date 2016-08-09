# Stampery Ruby
 Stampery API for Ruby. Notarize all your data using the blockchain!

# Usage
```ruby
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

 ```
## Installation
Coming soon

# Official implementations
- [NodeJS](https://github.com/stampery/node)
- [PHP](https://github.com/stampery/php)
- [Ruby](https://github.com/stampery/ruby)
- [Python](https://github.com/stampery/python)
- [Elixir](https://github.com/stampery/elixir)

# Feedback

Ping us at support@stampery.com and we’ll help you! 😃


## License

Code released under
[the MIT license](https://github.com/stampery/js/blob/master/LICENSE).

Copyright 2016 Stampery
