require 'spec_helper'

describe Category do
  it { should validate_presence_of :name }
  it { should validate_presence_of :user_id }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }

  it { should have_many(:activities).dependent(:nullify) }
  it { should belong_to(:user).dependent(:destroy) }
end
