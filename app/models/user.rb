class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name
  validates_presence_of :last_name

  has_many :activities, dependent: :destroy, inverse_of: :user
  has_many :categories, dependent: :destroy, inverse_of: :user
  has_many :activity_sessions, through: :activities, inverse_of: :user
end
