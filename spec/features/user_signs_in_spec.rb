require 'spec_helper'

feature 'Existing user signs in', %Q{
  As an existing, unauthenticated user
  I want to log in to my account
  So I can use the program
} do

  # Acceptance Criteria:
  #    * I must enter an email address and password
  #    * If I do not specify the required fields, I receive an error message.
  #    * If I do not specify an email address that is associated with account, I receive an error message.
  #    * If the password I enter does not match the password associated with the email address I entered, I receive an error message.
  #    * If I specify all of the required information, I am granted access to the system where I can track my activity.
  #    * If I don’t specify all the required info, I can’t access the system where I can track my activity.

  scenario 'supplies valid email and password' do
    user = FactoryGirl.create(:user)

    visit '/'
    click_on 'Sign In'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    expect(page).to have_content "Welcome, #{user.first_name}!"
    expect(page).to have_link 'Activities'
    expect(page).to have_link 'Sign Out'
  end

  scenario 'supplies invalid email'

  scenario 'supplies invalid password'

end
