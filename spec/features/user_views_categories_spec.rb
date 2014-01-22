require 'spec_helper'

feature 'Authenticated user views list of categories', %Q{
  As an authenticated user
  I want to view a list of my categories
  So I can decide whether to add or delete any
} do

  # Acceptance Criteria:
  # * I must be signed in to view a category
  # * If I’m not signed in, I am not allowed access to view a category
  # * I can click a link from my home screen to view a list of categories
  # * I can see the names of activities associated with each category, as well as the category name

  context 'authenticated user' do
    let!(:user) { FactoryGirl.create(:user) }

    scenario 'views categories' do
      categories = FactoryGirl.create_list(:category, 2, user: user)
      category1_activities = FactoryGirl.create_list(:activity, 2, user: user, category: categories.first)
      category2_activities = FactoryGirl.create_list(:activity, 2, user: user, category: categories.last)

      login(user)
      click_on 'My Categories'

      categories.each do |category|
        expect(page).to have_content category.name
        expect(page).to have_content "#{category.activities.first.name}, #{category.activities.last.name}"
      end
    end

    scenario 'has no categories' do
      login(user)
      click_on 'My Categories'

      expect(page).to have_content "You haven't created any categories yet"
    end
  end

  context 'unauthenticated user' do
    scenario 'unauthenticated user tries to view categories' do
      visit '/categories'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).to_not have_button 'My Categories'
    end
  end
end
