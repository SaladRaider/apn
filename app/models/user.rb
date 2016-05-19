class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  extend FriendlyId
  has_many :videos
  has_many :assigned_jobs

  friendly_id :username, use: :slugged

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :id_number, presence: true, length: { is: 5 }
  validates :password, confirmation: true
  validates :grade, presence: true, inclusion: { in: 9..12 }
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :username, presence: true, length: { minimum: 5 }, uniqueness: true

  has_attached_file :avatar, :styles => { :small => "150x150>", :medium => "200x200>", :large => "250x250>" },
    :url  => "/assets/users/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"

  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']

end
