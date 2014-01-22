require 'spec_helper'

feature 'Authenticated user adds an activity', %Q{
  As an authenticated user
  I want to add an activity
  So that the app can tell me to complete the activity when I use it
} do

  # Acceptance Criteria:
  #  * I must be signed in to add an activity
  #  * If I’m not signed in, I am not allowed access to add an activity
  #  * I must specify an activity name, estimated minimum time to complete the activity.
  #  * I can optionally specify a description
  #  * I can optionally specify a category
  #  * activity name must be unique
  #  * If I specify the required details, the activity is logged & I receive a friendly confirmation!
  #  * If I don’t, I’m presented with error messages
  #  * If the name of the activity I entered is already in my activity list, I receive an error message.

  context 'authenticated user' do

    let!(:user)       { FactoryGirl.create(:user) }
    let!(:category)   { FactoryGirl.create(:category, user: user) }
    let!(:activity)   { FactoryGirl.build(:activity, category: category) }

    context 'with valid attributes' do
      before :each do
        login(user)
        click_on 'Add Activity'
        fill_in 'activity_name', with: activity.name
        fill_in 'activity_description', with: activity.description
        fill_in 'activity_time_needed_in_min', with: activity.time_needed_in_min
      end

      scenario 'adds an activity with an existing category' do
        fill_in 'activity_category_string', with: activity.category_name
        click_button 'Create Activity'

        expect(page).to have_content 'Activity was successfully created.'
        expect(page).to have_button 'Create Activity'

        expect(Activity.first.category_name).to eq activity.category_name
      end

      scenario 'adds an activity with a new category' do
        fill_in 'activity_category_string', with: 'My New Category'
        click_button 'Create Activity'

        expect(page).to have_content 'Activity was successfully created.'
        expect(page).to have_button 'Create Activity'

        expect(Activity.first.category_name).to eq 'My New Category'
        expect(Category.count).to eq 2
      end

      scenario 'adds an activity without a category' do
        click_button 'Create Activity'

        expect(page).to have_content 'Activity was successfully created.'
        expect(page).to have_button 'Create Activity'
      end
    end

    context 'without valid attributes' do
      scenario 'adds an activity without required attributes' do
        login(user)
        click_on 'Add Activity'
        click_on 'Create Activity'

        expect(page).to have_button 'Create Activity'

        within '.input.activity_name' do
          expect(page).to have_content "can't be blank"
        end

        within '.input.activity_time_needed_in_min' do
          expect(page).to have_content "can't be blank"
        end
      end

      scenario 'adds an activity already in the list' do
        login(user)
        existing_activity = FactoryGirl.create(:activity, user: user)

        click_on 'Add Activity'
        fill_in 'activity_name', with: existing_activity.name
        fill_in 'activity_description', with: activity.description
        fill_in 'activity_time_needed_in_min', with: activity.time_needed_in_min
        click_button 'Create Activity'

        expect(Activity.count).to eq 1
        expect(page).to have_content 'has already been taken'
        expect(page).to have_button 'Create Activity'
      end
    end
  end

  context 'unauthenticated user' do
    scenario 'attempts to add an activity' do
      visit '/activities/new'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).to_not have_button 'Create Activity'
    end
  end
end
