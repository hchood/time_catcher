require 'spec_helper'

describe ActivitySession do
  it { should validate_presence_of :activity_id }
  it { should validate_presence_of :time_available }
  it { should validate_numericality_of(:time_available).is_greater_than(0) }

  it { should belong_to(:activity).dependent(:destroy) }
end
