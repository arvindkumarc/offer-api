class OffersController < ApplicationController
  def index
    unless params[:uid].nil?
      fyber = Fyber.new
      offer_response = fyber.get_offers(params[:uid], params[:pub0], params[:page])
      @offers = JSON.parse(offer_response)['offers']
      p @offers
    end
  end
end