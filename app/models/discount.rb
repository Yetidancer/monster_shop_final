class Discount < ApplicationRecord
  belongs_to :merchant

  validates :items_number, numericality: { greater_than: 0, only_integer: true }, presence: true

  validates :percent_off, numericality: { greater_than: 0, less_than_or_equal_to: 100, only_integer: true }, presence: true

end
