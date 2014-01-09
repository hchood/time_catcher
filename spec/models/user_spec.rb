require 'spec_helper'

describe User do
  let!(:user) { FactoryGirl.create(:user) }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should validate_uniqueness_of :email }

  it { should have_many(:activities).dependent(:destroy) }

end
