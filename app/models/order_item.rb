class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    quantity * price
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end

  def list_discounts
    self.item.merchant.discounts
  end

  def get_merchant_id
    self.item.merchant.id
  end

  def discount?
    self.quantity > self.list_discounts.minimum(:items_number)
  end

  def applied_discount
    Discount.where("items_number < ? AND merchant_id = ?", self.quantity, get_merchant_id).order(percent_off: :desc).first
  end
end
