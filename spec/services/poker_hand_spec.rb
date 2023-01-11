require 'rails_helper'

RSpec.describe PokerHand, type: :model do
  it { should validate_presence_of(:card_input) }
  
end