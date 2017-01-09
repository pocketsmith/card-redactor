require "spec_helper"

describe CardRedactor do

  it "detects a Visa number" do
    card = "some card 4111111111111111"
    expect(CardRedactor.contains_card?(card)).to be true
  end

  it "detects a Visa number with space delimiters" do
    card = "XYZ 4111 1111 1111 1111"
    expect(CardRedactor.contains_card?(card)).to be true
  end

  it "detects a Visa number with hyphen delimiters" do
    card = "4111-1111-1111-1111 blah"
    expect(CardRedactor.contains_card?(card)).to be true
  end

  it "detects Visa number amongst junk" do
    card = "xxxx+xxxx+xxxx+4111111111111111"
    expect(CardRedactor.contains_card?(card)).to be true
  end

  it "doesn't detect an NZ hyphen-delimited bank account" do
    num = "13-3015-0401063-00"
    expect(CardRedactor.contains_card?(num)).to be false
  end

  it "doesn't detect an NZ space-delimited bank account" do
    num = "04 0688 0292410 035"
    expect(CardRedactor.contains_card?(num)).to be false
  end

  it "redacts a Visa number" do
    card = "some card 4111111111111111"
    redacted = "some card XXXXXXXXXXXX1111"
    expect(CardRedactor.redact(card)).to eq(redacted)
  end

  it "redacts a Visa number with space delimiters" do
    card = "XYZ 4111 1111 1111 1111"
    redacted = "XYZ XXXX XXXX XXXX 1111"
    expect(CardRedactor.redact(card)).to eq(redacted)
  end

  it "redacts a Visa number with hyphen delimiters" do
    card = "4111-1111-1111-1111 blah"
    redacted = "XXXX-XXXX-XXXX-1111 blah"
    expect(CardRedactor.redact(card)).to eq(redacted)
  end

  it "redacts a Visa number amongst junk" do
    card = "xxxx+xxxx+xxxx+4111111111111111"
    redacted = "xxxx+xxxx+xxxx+XXXXXXXXXXXX1111"
    expect(CardRedactor.redact(card)).to eq(redacted)
  end

  it "redacts two cards" do
    card = "4111111111111111 4111111111113333"
    redacted = "XXXXXXXXXXXX1111 XXXXXXXXXXXX3333"
    expect(CardRedactor.redact(card)).to eq(redacted)
  end

  it "redacts two of the same card" do
    card = "4111111111111111 4111111111111111"
    redacted = "XXXXXXXXXXXX1111 XXXXXXXXXXXX1111"
    expect(CardRedactor.redact(card)).to eq(redacted)
  end

  it "redacts two cards with different delimiters" do
    card = "4111111111111111 4111-1111-1111-3333"
    redacted = "XXXXXXXXXXXX1111 XXXX-XXXX-XXXX-3333"
  end

  it "redacts two of the same card with different delimiters" do
    card = "4111111111111111 4111-1111-1111-1111"
    redacted = "XXXXXXXXXXXX1111 XXXX-XXXX-XXXX-1111"
    expect(CardRedactor.redact(card)).to eq(redacted)
  end

  it "redacts an AMEX card with no delimiters" do
    card = "375987651321001"
    redacted = "XXXXXXXXXXX1001"
    expect(CardRedactor.redact(card)).to eq(redacted)
  end

  it "redacts an AMEX card with delimiters" do
    card = "3759-876513-21001"
    redacted = "XXXX-XXXXXX-X1001"
    expect(CardRedactor.redact(card)).to eq(redacted)
  end

  it "leaves an NZ bank account number with hyphens alone" do
    num = "13-3015-0401063-00"
    expect(CardRedactor.redact(num)).to eq(num)
  end

  it "leaves an NZ bank accont with spaces alone" do
    num = "04 0688 0292410 035"
    expect(CardRedactor.redact(num)).to eq(num)
  end

  it "leaves an already redacted hyphenated card alone" do
    card = "XXXX-XXXX-XXXX-8104"
    expect(CardRedactor.redact(card)).to eq(card)
  end

end
