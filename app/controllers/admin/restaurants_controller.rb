class Admin::RestaurantsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to admin_restaurants_path
    else
      render :new
   end
 end

 def update
   @restaurant = Restaurant.find(params[:id])
   if @restaurant.update(restaurant_params)
      @restaurant.save
      redirect_to admin_restaurants_path
   else
     render :edit
   end
 end

 def destroy
   @restaurant = Restaurant.find(params[:id])
   @restaurant.destroy
   redirect_to :back
 end

 def restaurant_params
   params.require(:restaurant).permit(:name)
 end
end