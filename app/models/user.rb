class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :movies
  has_many :reviews, dependent: :destroy

  def self.find_first_by_auth_conditions(warden_conditions)
	  conditions = warden_conditions.dup
	  if login = conditions.delete(:login)
	    where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login.downcase }]).first
	  else
	    where(conditions).first
	  end
  end
  validates :username, presence: true, length: {maximum: 15}, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9]*\z/, message: "may only contain letters and numbers." }
  validates :password, :format => {:with => /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{3,}/, message: "Password must be at least 3 characters and include one number and one letter."}

  has_attached_file :avatar, :styles => { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
