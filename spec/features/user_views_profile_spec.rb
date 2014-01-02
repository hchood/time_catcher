require 'spec_helper'

feature 'An authenticated user views profile', %Q{
  As an authenticated user
  I can access a profile page
  So that I can view, edit, or delete my information
} do

  # Acceptance Criteria:
  # * After signing in, I am presented with a link to my profile page.
  # * I can view my first and last name and email address.
  # * I can edit my name and email address
  # * I can click on a link to delete my account.
  # * An unauthenticated user cannot view their profile.

  scenario 'authenticated user views profile' do
    user = FactoryGirl.create(:user)

    visit '/'
    click_on 'Sign In'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    click_link 'My Profile'

    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.email)
    expect(page).to have_link 'Delete My Account'
  end

  scenario 'unauthenticated user attempts to view profile' do
    visit '/'
    click_on 'Sign In'

    expect(page).to_not have_link 'My Profile'
  end
end
