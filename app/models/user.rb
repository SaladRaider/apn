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

  def get_current_grade
    now = DateTime.now
    current_grade = grade
    #created_date_time = created_at # "2016-05-10 23:03:24" "Tue, 10 May 2016 23:03:24 UTC +00:00:Time"
    starting_august_date = (created_at > DateTime.new(created_at.year, 8, 1)) ? DateTime.new(created_at.year, 8, 1) : DateTime.new(created_at.year - 1, 8, 1)
    current_august_date = (now > DateTime.new(now.year, 8, 1)) ? DateTime.new(now.year, 8, 1) : DateTime.new(now.year - 1, 8, 1)
    years_in_apn_completed = current_august_date.year - starting_august_date.year
    current_grade += years_in_apn_completed
    if current_grade > 12
      current_grade = 'Alumni'
    end
    return current_grade.to_s
  end

end
