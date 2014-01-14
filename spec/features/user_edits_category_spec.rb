require 'spec_helper'

feature 'user edits a category', %Q{
  As an authenticated user
  I want to edit a category
  So that I can correct misspellings or give it a better name
} do

  # Acceptance criteria:
  #    * I must be signed in to edit a category
  #    * If I’m not signed in, I am not allowed access to edit a category
  #    * From the categories screen, I must select a category to edit.
  #    * I must edit the category information or delete the category.
  #    * I must select “save changes”.  Changes to the category will be saved.
  #    * If I modify a category so that it has the same name as another
  # category in my list, I receive an error message.

  let!(:user)     { FactoryGirl.create(:user) }
  let!(:category) { FactoryGirl.create(:category, user: user) }

  scenario 'authenticated user updates category' do
    login(user)
    click_on 'My Categories'
    click_on 'Edit'
    fill_in 'Name', with: 'A Different Name'
    click_on 'Update Category'

    # displays success message
    expect(page).to have_content 'Changes saved!'

    # category attributes are updated
    expect(Category.first.name).to eq 'A Different Name'
  end

  scenario 'authenticated user deletes category'

  scenario 'category name already taken'

  scenario 'unauthenticated user attempts to edit or delete an activity'

end
