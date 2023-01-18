require 'rails_helper'

RSpec.describe PokerHand, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:card_input) }

    it 'is invalid with fewer than five cards' do
      hand = PokerHand.new(card_input: '2H 3H 4H')
      expect(hand).to_not be_valid
      expect(hand.errors.full_messages).to include('is less than five cards')
    end

    it 'is invalid with more than five cards' do
      hand = PokerHand.new(card_input: '2H 3H 4H 5H 6H 7H 8H')
      expect(hand).to_not be_valid
      expect(hand.errors.full_messages).to include('is more than five cards')
    end

    it 'is invalid with five cards of the same type' do
      hand = PokerHand.new(card_input: '5H 5C 5S 5D 5H')
      expect(hand).to_not be_valid
      expect(hand.errors.full_messages).to include("can't have five cards of the same type")
    end

    it 'is invalid with duplicate cards' do
      hand = PokerHand.new(card_input: '5H 6H 7H 8H 5H')
      expect(hand).to_not be_valid
      expect(hand.errors.full_messages).to include('contains duplicate cards')
    end

    it 'is invalid with unknown faces' do
      hand = PokerHand.new(card_input: '1H 2H 3H 4H 5H')
      expect(hand).to_not be_valid
      expect(hand.errors.full_messages).to include('contains unknown faces')
    end

    it 'is invalid with unknown suits' do
      hand = PokerHand.new(card_input: '2H 3H 4H 5H 6Y')
      expect(hand).to_not be_valid
      expect(hand.errors.full_messages).to include('contains unknown suits')
    end

    it 'is valid with a valid hand' do
      hand = PokerHand.new(card_input: 'AH AC 6D 5D 9D')
      expect(hand).to be_valid
    end
  end

  describe 'one_pair?' do
    it 'should return true with one pair' do
      hand = PokerHand.new(card_input: 'AH AC 4D 5D 9D')
      expect(hand.one_pair?).to be(true)
    end
    it 'should return false with two pairs' do
      hand = PokerHand.new(card_input: 'AH AC 4D 4C 9D')
      expect(hand.one_pair?).to be(false)
    end
    it 'should return false with four of a kind' do
      hand = PokerHand.new(card_input: 'AH AC AS AD 6H')
      expect(hand.one_pair?).to be(false)
    end
    it 'should return false with no pairs' do
      hand = PokerHand.new(card_input: 'AH 2C 3D 5D 9D')
      expect(hand.one_pair?).to be(false)
    end
    it 'should return false with full house' do
      hand = PokerHand.new(card_input: 'AH AC 5D 5C 5H')
      expect(hand.one_pair?).to be(false)
    end
  end

  describe 'two_pair?' do
    it 'should return true with two pairs' do
      hand = PokerHand.new(card_input: 'AH AC 5C 5D 9D')
      expect(hand.two_pair?).to be(true)
    end
    it 'should return false without two pairs' do
      hand = PokerHand.new(card_input: 'AH AC 4D 5D 9D')
      expect(hand.two_pair?).to be(false)
    end
    it 'should return false with a full house' do
      hand = PokerHand.new(card_input: 'AH AC 5C 5D 5H')
      expect(hand.two_pair?).to be(false)
    end
  end

  describe 'three_of_a_kind?' do
    it 'should return true with three cards of the same face' do
      hand = PokerHand.new(card_input: 'AH AC AD 5D 9D')
      expect(hand.three_of_a_kind?).to be(true)
    end
    it 'should return false with four cards of the same face' do
      hand = PokerHand.new(card_input: 'AH AC AD AS 9D')
      expect(hand.three_of_a_kind?).to be(false)
    end
    it 'should return false with full house' do
      hand = PokerHand.new(card_input: 'AH AC AD 5D 5C')
      expect(hand.three_of_a_kind?).to be(false)
    end
    it 'should return false without three of a kind' do
      hand = PokerHand.new(card_input: 'AH AC 4D 5D 9D')
      expect(hand.three_of_a_kind?).to be(false)
    end
  end

  describe 'straight?' do
    it 'should return true with five cards with consecutive numbers' do
      hand = PokerHand.new(card_input: 'AH 2C 3D 4D 5D')
      expect(hand.straight?).to be(true)
    end
    it 'should return false without five cards of consecutive numbers' do
      hand = PokerHand.new(card_input: 'AH AC 4D 5D 9D')
      expect(hand.straight?).to be(false)
    end
  end

  describe 'flush?' do
    it 'should return true if all cards have the same suits' do
      hand = PokerHand.new(card_input: 'AD 3D QD 5D 9D')
      expect(hand.flush?).to be(true)
    end
    it 'should return false if cards have more than one suit' do
      hand = PokerHand.new(card_input: 'AH AC KD 5D 9D')
      expect(hand.flush?).to be(false)
    end
  end

  describe 'full_house?' do
    it 'should return true with full house' do
      hand = PokerHand.new(card_input: 'AH AC 3D 3C 3S')
      expect(hand.full_house?).to be(true)
    end
    it 'should return false without a full house' do
      hand = PokerHand.new(card_input: 'AH AC 7D 5D 9D')
      expect(hand.full_house?).to be(false)
    end
  end

  describe 'four_of_a_kind?' do
    it 'should return true with four cards of the same value' do
      hand = PokerHand.new(card_input: 'AH AC AD AS 9D')
      expect(hand.four_of_a_kind?).to be(true)
    end
    it 'should return false without four cards of the same value' do
      hand = PokerHand.new(card_input: 'AH 3C QD 4H 7S')
      expect(hand.four_of_a_kind?).to be(false)
    end
  end

  describe 'straight_flush?' do
    it 'should return true with five consecutive cards of the same suit' do
      hand = PokerHand.new(card_input: '2H 3H 4H 5H 6H')
      expect(hand.straight_flush?).to be(true)
    end
    it 'should return false with five consecutive cards of different suits' do
      hand = PokerHand.new(card_input: '2H 3C 4D 5D 6D')
      expect(hand.straight_flush?).to be(false)
    end
    it 'should return false with five unconsecutive cards with the same suit' do
      hand = PokerHand.new(card_input: '4H 7H 5H 9H JH')
      expect(hand.straight_flush?).to be(false)
    end
  end
end
