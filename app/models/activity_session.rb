class ActivitySession < ActiveRecord::Base
  validates_presence_of :activity_id
  validates_presence_of :time_available
  validates_numericality_of :time_available, greater_than: 0

  belongs_to :activity, dependent: :destroy
  has_many :activity_selections, dependent: :destroy
  has_one :user, through: :activity

  def set_duration
     self.updated_at - self.created_at
  end

  def activities_already_selected
    activities = []
    activity_selections.each { |selection| activities << selection.activity }
    activities
  end

  class << self
    def activities_doable_given(user, time_available, activity_session = nil)
      all_doable_activities = Activity.where('user_id = :user_id AND time_needed_in_min <= :time_available', { user_id: user.id, time_available: time_available.to_i })
      if activity_session.nil?
        all_doable_activities
      else
        all_doable_activities - activity_session.activities_already_selected
      end
    end

    def random_activity_for(user, time_available, activity_session = nil)
      possible_activities = activities_doable_given(user, time_available, activity_session)
      rand_num = rand(possible_activities.count)
      possible_activities[rand_num]
    end
  end
end
