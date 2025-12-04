class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, through: :user_books
  has_many :user_books, dependent: :destroy
  has_many :shelves

  after_create :create_shelves

  def create_shelves
    ["To Read", "Read"].each do |shelf_name|
      shelf = Shelf.create!(user: self, name: shelf_name)
    end
  end
end
