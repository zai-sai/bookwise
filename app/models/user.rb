class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_books, dependent: :destroy
  has_many :books, through: :user_books

  has_many :shelves, dependent: :destroy
  has_many :shelf_books, through: :shelves
end
