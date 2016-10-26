# Stampery
Stampery API for Ruby. Notarize all your data using the blockchain!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stampery'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stampery

## Usage
```ruby
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
```

# Official implementations
- [NodeJS](https://github.com/stampery/node)
- [PHP](https://github.com/stampery/php)
- [ruby](https://github.com/stampery/ruby)
- [Python](https://github.com/stampery/python)
- [Elixir](https://github.com/stampery/elixir)
- [Java](https://github.com/stampery/java)
- [Go](https://github.com/stampery/go)

# Feedback

Ping us at support@stampery.com and we’ll help you! 😃


## License

Code released under
[the MIT license](https://github.com/stampery/js/blob/master/LICENSE).

Copyright 2016 Stampery
