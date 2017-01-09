require 'active_support'
require 'active_support/core_ext'

class CardRedactor

  # Matches Visa, Mastercard, AMEX, Discover
  # Read more: http://www.richardsramblings.com/regex/credit-card-numbers/
  CARD_PATTERN = /\b(?:3[47]\d{2}([\ \-+]?)\d{6}\1\d|(?:(?:4\d|5[1-5]|65)\d{2}|6011)([\ \-+]?)\d{4}\2\d{4}\2)\d{4}\b/

  class << self

    def contains_card?(string)
      card_matches(string).any?
    end

    def card_matches(string)
      # Scan to get all cards in the string, but get the Matchdata instead
      # Read more: http://stackoverflow.com/a/13817639/881691
      [].tap { |matches| string.scan(CARD_PATTERN) { matches << $~ } }
    end

    def redact(string)
      matches = card_matches(string)

      return string if matches.none?

      matches.each do |match|
        card = match[0]

        parts = []

        # In Ruby 1.9, there's no reliable way to deal with chars in strings
        # individually apart from splitting them into an array. In 2.x, we can
        # use array access notation to get at individual characters in a byte-safe manner.
        card.split("").reverse.each_with_index do |char, index|
          if index < 4 || char !~ /\d/
            parts << char
          else
            # If we've gone past the last 4 digits, redact numbers
            parts << "X"
          end
        end

        # Turn the numbers around the right way and implode them into a string
        redacted_card = parts.reverse.join("")

        # Replace the plaintext card with the redacted card in the original string
        string = string.sub(card, redacted_card)
      end

      string
    end

  end

end
