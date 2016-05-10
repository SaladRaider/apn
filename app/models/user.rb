class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :id_number, presence: true, length: { is: 5 }
	validates :password, confirmation: true
	validates :grade, presence: true, inclusion: { in: 9..12 }
	validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
	validates :username, presence: true, length: { minimum: 5 }, uniqueness: true
	has_many :videos
end
