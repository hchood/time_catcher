class Category < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :user_id

  validates_uniqueness_of :name, scope: :user_id

  has_many :activities, dependent: :nullify, inverse_of: :category
  belongs_to :user, inverse_of: :categories

  def activity_names
    names = activities.map { |activity| activity.name }
    names.join(", ")
  end
end
