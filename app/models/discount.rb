class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :items_number,
                        :percent_off
end
