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
    self.item.merchant_id
  end

  def discount?
    return false if list_discounts.blank?
    self.quantity >= self.list_discounts.minimum(:items_number)
  end

  def applicable_discount
    Discount.where("items_number <= ? AND merchant_id = ?", self.quantity, get_merchant_id).order(percent_off: :desc).first
  end

  def apply_discount
    discounted_price = ((100 - self.applicable_discount.percent_off) * 0.01 * self.price)
    self.update(discount_id: self.applicable_discount.id, price: discounted_price)
  end

  def discounted_subtotal
    (100 - self.applicable_discount.percent_off) * 0.01 * self.subtotal
  end
end
