class PokerHand

  include ActiveModel::Model

  attr_accessor :card_input

  validates_presence_of :card_input

  validate :valid_hand_size
  def valid_hand_size
    errors.add(:base, "is more than five cards") if cards.length > 5
    errors.add(:base, "is less than five cards") if cards.length < 5
  end

  validate :valid_cards
  def valid_cards
    invalid_suits = suits.select { |s| !["H", "D", "S", "C"].include?(s) }
    errors.add(:base, "contains unknown suits") if invalid_suits.present?
    invalid_faces = faces.select { |f| !(["A", "J", "Q", "K"] + (2..10).to_a).include?(f) }
    errors.add(:base, "contains unknown faces") if invalid_faces.present?
  end

  validate :duplicate_cards
  def duplicate_cards
    errors.add(:base, 'contains duplicate cards') unless cards.uniq.length == 5
    errors.add(:base, "can't have five cards of the same type") if faces.uniq.length == 1
  end

  def card_input
    @card_input ||= []
  end

  def straight_flush?
  end

  def four_of_a_kind?
  end

  def full_house?
  end

  def flush?
  end

  def straight?
  end

  def three_of_a_kind?
  end

  def two_pair?
  end

  def one_pair?
  end
  def cards
    @card_input&.split(' ')
  end

  def suits
    cards.map(&:last)
  end

  def faces
    cards.map { |x| x[0..-2]}
  end
end