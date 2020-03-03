class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      generate_flash(discount)
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to "/merchant/discounts"
    else
      generate_flash(@discount)
      render :edit
    end
  end

  def destroy
    merchant = current_user.merchant
    discount = merchant.discounts.find(params[:id])
    discount.destroy
    redirect_to '/merchant/discounts'
  end

  private
    def discount_params
      params.permit(:items_number, :percent_off)
    end
end
