class HomeController < ApplicationController
  def index; end

  def check_hand
    @hand = PokerHand.new(card_input: params[:card_input])
  end
end