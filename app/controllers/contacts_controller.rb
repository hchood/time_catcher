class ContactsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to new_contact_path, notice: "Thanks for your email!  We'll get back to you soon."
      ContactEmail.contact_us(@contact).deliver
    else
      flash[:notice] = "Uh oh! We encountered a problem."
      render 'new'
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :subject, :description)
  end
end
