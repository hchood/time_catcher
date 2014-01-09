class Category < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :user_id

  validates_uniqueness_of :name

  has_many :activities, dependent: :nullify
  belongs_to :user, dependent: :destroy
end
