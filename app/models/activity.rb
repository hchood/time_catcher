class Activity < ActiveRecord::Base
  validates_presence_of :time_needed_in_min
  validates_numericality_of :time_needed_in_min, greater_than: 0
  validates :name, presence: true, uniqueness: true

  belongs_to :category
  belongs_to :user
  has_many :activity_sessions, inverse_of: :activity

  def category_name
    if category.nil?
      ""
    else
      category.name
    end
  end
end
