class OffersController < ApplicationController
  def index
    unless params[:uid].nil?
      fyber = Fyber.new
      fyber_get_offers = fyber.get_offers(params[:uid], params[:pub0], params[:page])
      @offers = fyber_get_offers.response['offers']
      @errors = fyber_get_offers.errors
    end
  end
end