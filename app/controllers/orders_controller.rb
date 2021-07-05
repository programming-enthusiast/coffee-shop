class OrdersController < ApplicationController

  before_action :require_user

  def new
    @order = Order.new
  end

  def create
    @order = Order.create(order_params)
    @order.items << @cart.items_for_order
    if @order.save!
      session.delete(:cart)
      OrderMailer.order_complete(current_user, "Order was successfully placed. The total price of the order #{@order.id} is $#{@order.total_price}.")
      flash[:success] = 'Order was successfully placed'
      redirect_to orders_path
    else
      render :new
    end
  end

  def index
    @orders = current_user.orders.order('created_at DESC')
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private
  def order_params
    params.require(:order).permit(:user_id, address_attributes: [:address, :zipcode, city_attributes: [:name, :state_id]])
  end
end
