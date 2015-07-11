class OffersController < ApplicationController
  def index
    unless params[:uid].nil?
      fyber = Fyber.new
      @offers = fyber.get_offers(params[:uid], params[:pub0], params[:page])['offers']
    end
  end
end