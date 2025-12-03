class UserBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  delegate :title, :description, :author, to: :book # new method to no do user_
end
