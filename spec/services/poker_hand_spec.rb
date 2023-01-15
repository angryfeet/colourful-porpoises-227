require 'rails_helper'

RSpec.describe PokerHand, type: :model do
  it { should validate_presence_of(:card_input) }

  it "is invalid with fewer than five cards" do
    hand = PokerHand.new(card_input: '2H 3H 4H')
    expect(hand).to_not be_valid
  end

  it "is invalid with more than five cards" do
    hand = PokerHand.new(card_input: "2H 3H 4H 5H 6H 7H 8H")
    expect(hand).to_not be_valid
  end

  it "is invalid with five cards of the same type" do
    hand = PokerHand.new(card_input: '5H 5C 5S 5D 5H')
    expect(hand).to_not be_valid
    expect(hand.errors).to include("can't have five cards of the same type")
  end

  it "is invalid with duplicate cards" do
    hand = PokerHand.new(card_input: "5H 6H 7H 8H 5H")
    expect(hand).to_not be_valid
  end

  it "is invalid with unknown cards" do
    hand = PokerHand.new(card_input: '1H 2H 3H 4H 5H')
    expect(hand).to_not be_valid
  end

  it "is invalid with unknown suits" do
    hand = PokerHand.new(card_input: '2H 3H 4H 5H 6Y')
    expect(hand).to_not be_valid
  end

  it "is valid with a valid hand"
end