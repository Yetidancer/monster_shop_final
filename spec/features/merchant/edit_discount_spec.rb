require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Discount Index' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
      @nessie = @merchant_1.items.create!(name: 'Nessie', description: "I'm a Loch Monster!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 50 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 6, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 12, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 7, fulfilled: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      @discount_1 = @merchant_1.discounts.create!(percent_off: 10, items_number: 5)
      @discount_2 = @merchant_1.discounts.create!(percent_off: 20, items_number: 10)
    end

    it 'I can click a link to get to a discount edit page' do
      visit "/merchant/discounts"

      within "#discount-#{@discount_1.id}" do
        click_button "Edit"
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
    end

    it 'I can edit the discounts information' do
      percent_off = 10
      items_number = 10

      visit "/merchant/discounts/#{@discount_1.id}/edit"

      fill_in :percent_off, with: percent_off
      fill_in :items_number, with: items_number

      click_button "Update Discount"

      expect(current_path).to eq("/merchant/discounts")
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content(percent_off)
        expect(page).to have_content(items_number)
      end
    end

    it 'I can not edit the discount with an incomplete form' do
      percent_off = 10
      items_number = ""

      visit "/merchant/discounts/#{@discount_1.id}/edit"

      fill_in :percent_off, with: percent_off
      fill_in :items_number, with: items_number
      click_button 'Update Discount'

      expect(page).to have_content("items_number: [\"is not a number\", \"can't be blank\"]")
      expect(page).to have_button('Update Discount')

      items_number = 10

      visit "/merchant/discounts/#{@discount_1.id}/edit"

      fill_in :items_number, with: items_number

      click_button 'Update Discount'

      expect(page).to have_content("percent_off: [\"is not a number\", \"can't be blank\"]")
    end

    it 'I can not create a discount for a merchant with an incorrect form' do
      percent_off = 101
      items_number = 10

      visit "/merchant/discounts/#{@discount_1.id}/edit"

      fill_in :percent_off, with: percent_off
      fill_in :items_number, with: items_number

      click_button 'Update Discount'

      expect(page).to have_content("percent_off: [\"must be less than or equal to 100\"]")
      expect(page).to have_button('Update Discount')

      percent_off = 55.5
      items_number = 10

      visit "/merchant/discounts/#{@discount_1.id}/edit"

      fill_in :percent_off, with: percent_off
      fill_in :items_number, with: items_number

      click_button 'Update Discount'

      expect(page).to have_content("percent_off: [\"must be an integer\"]")
      expect(page).to have_button('Update Discount')

      percent_off = 50
      items_number = -10

      visit "/merchant/discounts/#{@discount_1.id}/edit"

      fill_in :percent_off, with: percent_off
      fill_in :items_number, with: items_number

      click_button 'Update Discount'

      expect(page).to have_content("items_number: [\"must be greater than 0\"]")
      expect(page).to have_button('Update Discount')
    end
  end
end
