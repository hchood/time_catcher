require 'spec_helper'

feature 'User sends email to staff via Contact Us form', %Q{
  As a site visitor
  I want to contact the site's staff
  So that I can ask questions or make comments about the site
} do

  # Acceptance Criteria:

  # I must specify a valid email address
  # I must specify a subject
  # I must specify a description
  # I must specify a first name
  # I must specify a last name

  before :each do
    ActionMailer::Base.deliveries = []
  end

  scenario 'submits email with valid attributes' do
    prev_count = Contact.count
    contact = FactoryGirl.build(:contact)

    visit '/'
    click_on 'Contact Us'
    fill_in 'contact_first_name', with: contact.first_name
    fill_in 'contact_last_name', with: contact.last_name
    fill_in 'contact_email', with: contact.email
    fill_in 'contact_subject', with: contact.subject
    fill_in 'contact_description', with: contact.description
    click_button 'Submit'

    expect(page).to have_content("Thanks for your email!  We'll get back to you soon.")
    expect(Contact.count).to eq prev_count + 1

    expect(ActionMailer::Base.deliveries.size).to eq 1
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email).to have_subject "TimeCatcher:  Contact from #{contact.first_name} #{contact.last_name}"
    expect(last_email).to deliver_to 'helen.c.hood@gmail.com'
  end

  scenario 'submits email with missing attributes'

  scenario 'submits email with invalid email'

end
