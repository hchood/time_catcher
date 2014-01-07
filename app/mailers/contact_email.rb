class ContactEmail < ActionMailer::Base
  default to: 'helen.c.hood@gmail.com'

  def contact_us(contact)
    @contact = contact

    mail from: contact.email,
      subject: "TimeCatcher:  Contact from #{contact.first_name} #{contact.last_name}"
  end
end
