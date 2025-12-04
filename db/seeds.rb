# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"
require "nokogiri"
require "json"
require "faker"
# books = []

# limit = 1000
# offset = 0

# # subjects = ["fantasy", "science fiction", "horror", "mystery", "thriller", "romance", "biography", "history", "travel", "food", "art", "music", "film", "tv", "theater", "dance", "fashion", "architecture", "design", "architecture", "design", "architecture", "design"]
# subjects = ["fantasy"]
# subjects.each do |subject|
#   running = true
#   while running
#     url = "https://openlibrary.org/subjects/#{subject}.json?limit=#{limit}&offset=#{offset}"

#     result = JSON.parse(URI.open(url).read)
#     if result["works"].empty?
#       running = false
#     end
#     result["works"].each do |work|
#       books << {
#         title: work["title"],
#         author: work["authors"].first.nil? ? "" : work["authors"].first["name"],
#         subject: work["subject"],
#         url: "https://openlibrary.org/" + work["key"] + ".json"
#       }
#     end
#     offset += limit
#     puts "Offset: #{offset}"
#     puts "Links: #{books.size}"
#     puts "--------------------------------"
#   end

#   CSV.open("openlibrary_#{subject}.csv", "w") do |csv|
#     csv << books.first.keys
#     books.each do |book|
#       csv << book.values
#     end
#   end
# end

image_link = "https://rhbooks.com.ng/wp-content/uploads/2022/03/book-placeholder.png"
100.times do
  Book.create!(
    title: Faker::Book.title,
    author: Faker::Book.author,
    # genre: Faker::Book.genre,
    description: "A great #{Faker::Book.genre} book",
    image_link:
  )
end
user = User.create!(username: "spongebob", email: "example@example.com", password: "password")


["My Fantasy Shelf", "My Crime Shelf"].each do |shelf_name|
  shelf = Shelf.create!(user: user, name: shelf_name)
  (5..10).to_a.sample.times do
    user_book = UserBook.create!(book: Book.all.sample, user: user, status: ["read", "unread"].sample)

    ShelfBook.create!(shelf: shelf, user_book: user_book)

  end
end
