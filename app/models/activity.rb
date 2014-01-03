class Activity < ActiveRecord::Base
  validates :time_needed_in_min, presence: true, numericality: true
  validates :name, presence: true, uniqueness: true

  belongs_to :category
  belongs_to :user

  def category_name
    if category.nil?
      ""
    else
      category.name
    end
  end
end
