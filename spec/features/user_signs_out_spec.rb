require 'spec_helper'

feature 'Authenticated user signs out', %Q{
  As an authenticated user
  I want to be able to log out of the program from my home screen
  So that I can close the app
  } do

  # Acceptance criteria:
  #  * I must be signed in to log out.
  #  * If I’m not signed in, I am not allowed access to log out.
  #  * I must be on my home screen to log out. [other scenarios can be tested elsewhere?]

  scenario 'an authenticated user signs out' do
    user = FactoryGirl.create(:user)

    visit '/'
    click_on 'Sign In'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    click_link 'Sign Out'
    expect(page).to have_link 'Sign In'
    expect(page).to have_link 'Sign Up'
    expect(page).to_not have_link 'Sign Out'
  end

  scenario 'an unauthenticated or non-registered user attempts to sign out' do
    visit '/'

    expect(page).to_not have_link 'Sign Out'
  end
end
