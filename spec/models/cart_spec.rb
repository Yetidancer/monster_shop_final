require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @giant = @brian.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )
      @discount_1 = @brian.discounts.create!(items_number: 10, percent_off: 10)
      @discount_2 = @brian.discounts.create!(items_number: 5, percent_off: 5)
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 6
        })
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 6
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 6,
        @hippo.id.to_s => 1
        })
    end

    it '.count' do
      expect(@cart.count).to eq(7)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(320)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(6)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(300)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(true)
      expect(@cart.limit_reached?(@giant.id)).to eq(false)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(5)
    end

    it '.list_discounts()' do
      expect(@cart.list_discounts(@giant)).to eq([@discount_1, @discount_2])
    end

    it '.discount?()' do
      expect(@cart.discount?(@giant)).to eq(true)
    end

    it '.applied_discount()' do
      expect(@cart.applied_discount(@giant)).to eq(@discount_2)
    end

    it '.discounted_subtotal()' do
      expect(@cart.discounted_subtotal(@giant)).to eq(285)
    end
  end
end
