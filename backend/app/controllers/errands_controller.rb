class ErrandsController < ApplicationController
  respond_to :json
  def index
    #render json: Errand.where(:user => current_user).all
    @errands = Errand.all

    long = lat = nil
    if params['longitude']
      long = params['longitude'].to_f
      lat = params['latitude'].to_f
    elsif warden.user and warden.user.longitude
      long = warden.user.longitude
      lat = warden.user.latitude
    end

    if long
      @errands = @errands.sort_by {|x| x.distance_to([lat, long]) }
    end

    render json: @errands
  end

  def show
    render json: Errand.find(params[:id])
  end

  def create
    errand = Errand.new
    errand.update_attributes(params['errand'])
    render json: errand
  end

  def update
    errand = Errand.find(params[:id])
    errand.update_attributes(params)
    render json: errand
  end

  def destroy
    errand = Errand.find(params[:id])
    errand.delete!
  end
end
