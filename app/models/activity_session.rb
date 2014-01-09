class ActivitySession < ActiveRecord::Base
  validates_presence_of :activity_id
  validates_presence_of :time_available
  validates_numericality_of :time_available, greater_than: 0

  belongs_to :activity, dependent: :destroy
  has_many :activity_selections, dependent: :destroy

  def set_duration
     self.updated_at - self.created_at
  end

  class << self
    def activities_doable_in(time_available)
      Activity.where('time_needed_in_min <= :time_available', { time_available: time_available.to_i })
    end

    def random_activity_for(time_available)
      possible_activities = activities_doable_in(time_available)
      rand_num = rand(possible_activities.count)
      activities_doable_in(time_available)[rand_num]
    end
  end
end
