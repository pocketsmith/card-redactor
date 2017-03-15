# CardRedactor

A gem for detecting sensitive [credit card PANs](https://en.wikipedia.org/wiki/Payment_card_number) in strings, and redacting them. All digits, except the trailing 4, are replaced with X. The original format of the number is kept intact. Supports Visa, Mastercard, AMEX, and Discover. Useful for cases where user input may inadvertently contain credit card numbers, and you want to ensure they aren't stored.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'card_redactor', '~> 1.0.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install card_redactor

## Usage

Firstly, `CardRedactor` can be used to detect the presence of a credit card PAN in a string:

```ruby
>> card = "4111-1111-1111-1111"
=> "4111-1111-1111-1111"
>> CardRedactor.contains_card?(card)
=> true
```

Secondly, you can redact those PANs, replacing all but the last 4 digits with Xs:

```ruby
>> CardRedactor.redact(card)
=> "XXXX-XXXX-XXXX-1111"
```

It'll work with natural language sentences, and leave numbers that aren't credit cards alone:

```ruby
>> card = "A more complex example, with an NZ bank account 12-1212-343434-01 and a credit card 4111111111111111, wow!"
=> "A more complex example, with an NZ bank account 12-1212-343434-01 and a credit card 4111111111111111, wow!"
>> CardRedactor.contains_card?(card)
=> true
>> CardRedactor.redact(card)
=> "A more complex example, with an NZ bank account 12-1212-343434-01 and a credit card XXXXXXXXXXXX1111, wow!"
```

and strings that contain more than one PAN:

```ruby
>> card = "I've got 4111111111111111 and 3759-876513-21001"
=> "I've got 4111111111111111 and 3759-876513-21001"
>> CardRedactor.redact(card)
=> "I've got XXXXXXXXXXXX1111 and XXXX-XXXXXX-X1001"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocketsmith/card-redactor.

