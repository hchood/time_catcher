require 'spec_helper'

describe Activity do
  let!(:activity) { FactoryGirl.create(:activity) }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :time_needed_in_min }
  it { should validate_numericality_of(:time_needed_in_min).is_greater_than(0) }

  it { should belong_to :category }
  it { should belong_to :user }
  it { should have_many :activity_sessions }
end
