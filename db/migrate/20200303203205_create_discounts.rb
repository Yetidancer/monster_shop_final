class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :items_number
      t.integer :percent_off
    end
  end
end
