require 'spec_helper'

describe ContactEmail do
  describe 'contact_us' do
    let(:contact) { FactoryGirl.build(:contact) }
    let(:mail) { ContactEmail.contact_us(contact) }

    it 'renders the headers' do
      mail.subject.should eq "TimeCatcher:  Contact from #{contact.first_name} #{contact.last_name}"
      mail.to.first.should eq 'helen.c.hood@gmail.com'
      mail.from.first.should eq contact.email
    end

    it 'renders the body' do
      mail.body.should have_content "#{contact.first_name} #{contact.last_name}"
      mail.body.should have_content contact.subject
      mail.body.should have_content contact.description
    end
  end
end
