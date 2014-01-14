class Category < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :user_id

  validates_uniqueness_of :name, scope: :user_id

  has_many :activities, dependent: :nullify
  belongs_to :user
end
