class AddDiscountToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_items, :discount, foreign_key: true
  end
end
