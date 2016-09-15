class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :recoverable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
    :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
	has_many :authentications
	has_many :metadata
	validates :name, presence: true
	validates :email, uniqueness: true
	
	def password_required?
  	(authentications.empty? || !password.blank?) && super
  end
end