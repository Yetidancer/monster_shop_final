require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'New Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to a new discount form page' do
      visit "/merchant/discounts"

      click_link 'New Discount'

      expect(current_path).to eq("/merchant/discounts/new")
    end

    it 'I can create a discount for a merchant' do
      items_number = 5
      percent_off = 10

      visit "/merchant/discounts/new"

      fill_in :items_number, with: items_number
      fill_in :percent_off, with: percent_off

      click_button "Create Discount"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content(items_number)
      expect(page).to have_content(percent_off)
    end

    it 'I can not create a discount for a merchant with an incomplete form' do
      percent_off = 10

      visit "/merchant/discounts/new"

      fill_in :percent_off, with: percent_off

      click_button 'Create Discount'

      expect(page).to have_content("items_number: [\"is not a number\", \"can't be blank\"]")
      expect(page).to have_button('Create Discount')

      items_number = 10

      visit "/merchant/discounts/new"

      fill_in :items_number, with: items_number

      click_button 'Create Discount'

      expect(page).to have_content("percent_off: [\"is not a number\", \"can't be blank\"]")
    end

    it 'I can not create a discount for a merchant with an incorrect form' do
      percent_off = 101
      items_number = 10

      visit "/merchant/discounts/new"

      fill_in :percent_off, with: percent_off
      fill_in :items_number, with: items_number

      click_button 'Create Discount'

      expect(page).to have_content("percent_off: [\"must be less than or equal to 100\"]")
      expect(page).to have_button('Create Discount')

      percent_off = 55.5
      items_number = 10

      visit "/merchant/discounts/new"

      fill_in :percent_off, with: percent_off
      fill_in :items_number, with: items_number

      click_button 'Create Discount'

      expect(page).to have_content("percent_off: [\"must be an integer\"]")
      expect(page).to have_button('Create Discount')

      percent_off = 50
      items_number = -10

      visit "/merchant/discounts/new"

      fill_in :percent_off, with: percent_off
      fill_in :items_number, with: items_number

      click_button 'Create Discount'

      expect(page).to have_content("items_number: [\"must be greater than 0\"]")
      expect(page).to have_button('Create Discount')
    end
  end
end
