require 'spec_helper'

describe ActivitySelection do
  it { should validate_presence_of :activity_id }
  it { should validate_presence_of :activity_session_id }

  it { should belong_to :activity_session }
  it { should belong_to :activity }
end
