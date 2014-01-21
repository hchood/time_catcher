require 'spec_helper'

feature 'site visitor views about us page', %Q{
  As a site visitor
  I want to view the About Us page
  So that I can learn about the app
} do

  # ACCEPTANCE CRITERIA:
  # *   From the homepage, I can click on "About Us" and will be taken to a description of the app.
  # *   I can access the page whether or not I am logged in.

  scenario 'non-authenticated user views About Us page' do
    visit '/'
    click_on 'About Us'

    expect(page).to have_content 'Launch Academy'
  end

  scenario 'authenticated user views About Us page' do
    user = FactoryGirl.create(:user)
    login(user)
    visit '/'
    click_on 'About Us'

    expect(page).to have_content 'Launch Academy'
  end
end
