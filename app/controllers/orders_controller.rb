class OrdersController < ApplicationController
  def index
    # @orders = Order.all
    @orders = current_user.orders
  end

  def show
    @Order = Order.find(params[:id])
    # Setting orderitem pour le show des child_orders
    @orderitem = @Order.orders.first.order_items if @Order.orders.first
    # Setting shop_id pour récupérer l'id du shop à partir de l'order
    @orders = Order.all
    @shop_id = @orders.first.order_items.first.item.shop_id

    # child_user geolocation set-up
    #@order_latitude = @Order.orders.first.user.latitude
    #@order_longitude = @Order.orders.first.user.longitude
    @shop_coordinates = { lat: @Order.orders.first.user.latitude, lng: @Order.orders.first.user.longitude }

    @hash = Gmaps4rails.build_markers(@shop) do |shop, marker|
      marker.lat shop.latitude
      marker.lng shop.longitude
    end

  end

  def add_to_cart
    session[:carts] = {} unless session[:carts].present?
    session[:carts][params[:id]] = {} unless session[:carts][params[:id]].present?
    session[:carts][params[:id]][params[:item_id]] = session[:carts][params[:id]][params[:item_id]].to_i + 1

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { render json: session[:json] }
    end
  end

  def cart
    session[:carts]
    @shop = Shop.find(session[:carts].keys.first.to_i)

    @item_data = session[:carts][params[:id]].to_a

    @orders = Order.all
    # @orderitem = @Order.orders.first.order_items if @Order.orders.first
    @shop_id = @orders.first.order_items.first.item.shop_id

    respond_to do |format|
      format.html { render 'orders/cart'}
    end
  end

  def validate

  end

end
