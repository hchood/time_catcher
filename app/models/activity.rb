class Activity < ActiveRecord::Base
  validates_presence_of :time_needed_in_min
  validates_numericality_of :time_needed_in_min, greater_than: 0

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :user_id

  belongs_to :category, inverse_of: :activities
  belongs_to :user, inverse_of: :activities
  has_many :activity_sessions, dependent: :destroy, inverse_of: :activity
  has_many :activity_selections, dependent: :destroy, inverse_of: :activity

  def category_name
    if category.nil?
      ""
    else
      category.name
    end
  end

  def category_string
  end

  def category_string=(value)
  end
end
