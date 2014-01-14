class ActivitySelection < ActiveRecord::Base
  validates_presence_of :activity_session_id
  validates_presence_of :activity_id

  belongs_to :activity_session, inverse_of: :activity_selections
  belongs_to :activity, inverse_of: :activity_selections
end
