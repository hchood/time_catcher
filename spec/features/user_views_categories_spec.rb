require 'spec_helper'

feature 'Authenticated user views list of categories', %Q{
  As an authenticated user
  I want to view a list of my categories
  So I can decide whether to add or delete any
} do

  # Acceptance Criteria:
  # * I must be signed in to add a category
  # * If I’m not signed in, I am not allowed access to add a category
  # * I can click a link from my home screen to view a list of categories

  scenario 'authenticated user views categories' do
    user = FactoryGirl.create(:user)
    category1 = FactoryGirl.create(:category, user: user)
    category2 = FactoryGirl.create(:category, user: user)

    login(user)
    click_on 'My Categories'

    expect(page).to have_content category1.name
    expect(page).to have_content category2.name
  end

  scenario 'unauthenticated user tries to view categories' do
    visit '/categories'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
    expect(page).to_not have_button 'My Categories'
  end
end
