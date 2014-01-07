require 'spec_helper'

describe Contact do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :subject }
  it { should validate_presence_of :description }

  it { should validate_presence_of :email}
  it { should have_valid(:email).when('jsmith@gmail.com', 'john.smith@williams.edu', 'someone@something.io') }
  it { should_not have_valid(:email).when(nil, '', '@gmail', '@williams.edu', 'john.smith', 'abc@website') }
end
