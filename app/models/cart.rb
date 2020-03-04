class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def list_discounts(item)
    item.merchant.discounts
  end

  def discount?(item)
    return false if list_discounts(item).blank?
    self.count_of(item.id) >= self.list_discounts(item).minimum(:items_number)
  end

  def applicable_discount(item)
    Discount.where("items_number <= ? AND merchant_id = ?", self.count_of(item.id), item.merchant_id).order(percent_off: :desc).first
  end

  def discounted_subtotal(item)
    (100 - self.applicable_discount(item).percent_off) * 0.01 * self.subtotal_of(item.id)
  end
end
