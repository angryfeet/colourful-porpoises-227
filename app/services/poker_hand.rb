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

  def check_hand
    return 'Straight flush' if straight_flush?
    return 'Four of a kind' if four_of_a_kind?
    return 'Full house' if full_house?
    return 'Flush' if flush?
    return 'Straight' if straight?
    return 'Three of a kind' if three_of_a_kind?
    return 'Two pair' if two_pair?
    return 'One pair' if one_pair?

    'High card'
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    face_groups.any? { |_, x| x.length == 4 }
  end

  def full_house?
    face_groups.length == 2 &&
      face_groups.any? { |_, x| x.length == 2 } &&
      face_groups.any? { |_, x| x.length == 3 }
  end

  def flush?
    suits.uniq.length == 1
  end

  def straight?
    straight = face_values.sort.each_cons(2).all? { |x, y| x + 1 == y }
    straight = face_values(ace_high: false).sort.each_cons(2).all? { |x, y| x + 1 == y } if !straight && faces.any? { |x| x == 'A' }
    straight
  end

  def three_of_a_kind?
    face_groups.any? { |_, x| x.length == 3 } &&
      face_groups.length == 3
  end

  def two_pair?
    face_groups.select { |_, x| x.length == 2 }.length == 2
  end

  def one_pair?
    face_groups.select { |_, x| x.length == 2 }.length == 1 &&
      face_groups.length == 4
  end

  private

  def cards
    @card_input&.split(' ')
  end

  def suits
    cards.map(&:last)
  end

  def faces
    cards.map { |x| x[0..-2] }
  end

  def face_values(ace_high: true)
    faces.map do |f|
      case f
      when 'K'
        '13'
      when 'Q'
        '12'
      when 'J'
        '11'
      when 'A'
        ace_high ? '14' : '1'
      else
        f
      end
    end.map(&:to_i)
  end

  def face_groups
    faces.group_by(&:itself)
  end
end
