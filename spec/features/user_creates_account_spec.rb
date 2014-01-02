require 'spec_helper'

feature 'New user creates account', %Q{
    As a new user
    I want to create an account
    So I can keep track of my activity
  } do

  # Acceptance Criteria:
  #  * I must specify an email address, a first name, a last name, a password, & a password confirmation.
  #  * If I do not specify the required fields, I receive an error message.
  #  * If I specify all the required information, I am granted access to the system where I can track my activity.
  #  * If I don’t specify all the required info, I can’t access the system where I can track my activity.
  #  * I must specify a valid email that is not already in use.
  #  * My password confirmation must match the specified password.

  scenario 'supplies all required, valid information' do
    user = FactoryGirl.build(:user)

    visit '/'
    click_button 'Sign Up'

    fill_in 'First Name', with: user.first_name
    fill_in 'Last Name', with: user.last_name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password Confirmation', with: user.password_confirmation

    click_button 'Sign me up!'

    # it signs the user in
    expect(page).to have_content "Welcome, #{user.first_name}!"
    expect(page).to have_content 'Sign Out'

    # it adds the user to the database
    expect(User.all.count).to eq 1
  end

  scenario 'does not supply required information' do
    visit '/'
    click_button 'Sign Up'

    click_button 'Sign me up!'

    # it does not sign the user in
    expect(page).to_not have_content "Welcome, #{user.first_name}!"
    expect(page).to have_content 'Sign me up!'

    # it displays errors
    expect(page).to have_content "can't be blank"

    # it does not add the user to the database
    expect(User.all.count).to eq 0
  end

  scenario 'email is already in use' do
    existing_user = FactoryGirl.create(:user)
    new_user = FactoryGirl.build(:user, email: existing_user.email)

    visit '/'
    click_button 'Sign Up'

    fill_in 'First Name', with: new_user.first_name
    fill_in 'Last Name', with: new_user.last_name
    fill_in 'Email', with: new_user.email
    fill_in 'Password', with: new_user.password
    fill_in 'Password Confirmation', with: new_user.password_confirmation

    click_button 'Sign me up!'

    # it does not sign the user in
    expect(page).to_not have_content "Welcome, #{user.first_name}!"
    expect(page).to have_content 'Sign me up!'

    # it displays errors
    expect(page).to have_content 'That email address has been taken!'

    # it does not add the new user to the database
    expect(User.all.count).to eq 1
  end

  scenario 'password confirmation does not match password' do
    user = FactoryGirl.build(:user)

    visit '/'
    click_button 'Sign Up'

    fill_in 'First Name', with: user.first_name
    fill_in 'Last Name', with: user.last_name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password Confirmation', with: 'wrong_password'

    click_button 'Sign me up!'

    # it does not sign the user in
    expect(page).to_not have_content "Welcome, #{user.first_name}!"
    expect(page).to have_content 'Sign me up!'

    # it displays errors
    expect(page).to have_content 'Passwords do not match'

    # it does not add the user to the database
    expect(User.all.count).to eq 0
  end

  scenario 'does not supply valid email'
end
