require 'spec_helper'

feature 'user edits an activity', %Q{
  As an authenticated user
  I want to edit an activity
  So that I can correct mistakes or change the amount of time needed for the activity or delete an activity
} do

  # Acceptance criteria:
  #    * I must be signed in to edit an activity
  #    * If I’m not signed in, I am not allowed access to edit an activity
  #    * From the '/activities' page, I must select an activity to edit.
  #    * I must edit the activity information or delete the activity.
  #    * I must select “save changes”.  Changes to the activity list will be saved.
  #    * If I modify an activity so that it has the same name as another activity in my
  # activity list, I receive an error message.
  #    * If I do not specify all require attributes, I receive an error message.

  let!(:user)     { FactoryGirl.create(:user) }
  let!(:activity) { FactoryGirl.create(:activity, user: user) }

  scenario 'authenticated user updates activity' do
    login(user)
    click_on 'My Activities'
    click_on 'Edit'
    fill_in 'Name', with: 'A Different Name'
    fill_in 'Time Needed', with: 20
    click_on 'Update Activity'

    # displays success message
    expect(page).to have_content 'Changes saved!'

    # activity attributes are updated
    expect(Activity.first.name).to eq 'A Different Name'
    expect(Activity.first.time_needed_in_min).to eq 20
  end

  scenario 'authenticated user deletes activity' do
    login(user)
    click_on 'My Activities'
    click_on 'Delete'

    # displays success message
    expect(page).to have_content 'Activity has been deleted.'

    # does not display
    expect(page).to_not have_content activity.name
  end

  scenario 'missing attributes' do
    login(user)
    click_on 'My Activities'
    click_on 'Edit'
    fill_in 'Name', with: ''
    click_on 'Update Activity'

    # displays error message
    expect(page).to have_content "can't be blank"

    # activity attributes are not updated
    expect(Activity.first.name).to eq activity.name
  end

  scenario 'activity name already taken' do
    existing_activity = FactoryGirl.create(:activity, user: user)

    login(user)
    click_on 'My Activities'
    first(:link, 'Edit').click
    fill_in 'Name', with: existing_activity.name
    click_on 'Update Activity'

    # displays error message
    expect(page).to have_content "has already been taken"

    # activity attributes are not updated
    expect(Activity.first.name).to eq activity.name
  end

  scenario 'unauthenticated user attempts to edit or delete an activity' do
    visit '/activities'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
    expect(page).to_not have_link 'Edit'
    expect(page).to_not have_link 'Delete'
  end
end
