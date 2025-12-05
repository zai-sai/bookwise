class UserBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  # Active record method, allows UserBook to inherit attributes from Book
  # Can only be used on models with belongs_to (inherit from parent)
  delegate :title, :description, :author, :image_link, to: :book

  # enum convert status values into numbers.
    # So our database: the status column hold an integter (0, 1, or 2)
    # And in our code: 0=unread, 1=read, 2=in_progress
  # We can still do examplebook.read? and it'll tell us true or false
  # If we do UserBook.new(title: xyz, description: abc, status: read), it'll convert read to 1
  enum status: {
    unread: 0,
    read: 1,
    in_progress: 2
  }
  # The enum above does the same thing as this validation:
    # validates :status, inclusion: { in: ["unread", "read", "in_progress"] }
  # According to French Ben enum is the professional way to define a scope of options for a column

  # Scope creates a class method similar to .all
  # eg. we can now do UserBook.unread and it'll give us an array of books with 'status: :unread'
  # Note, the numbers (eg 'status: 0') are coming from the enum above
  scope :unread, -> { where(status: 0) }
  scope :read, -> { where(status: 1) }
  scope :in_progress, -> { where(status: 2) }
end
