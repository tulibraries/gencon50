class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable, 
  devise :database_authenticatable, :trackable, :rememberable, :validatable
end
