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

def seed_from_apis

  books = []

  limit = 25
  # subjects_done = ["nonfiction", "romance", "scifi", "horror", "mystery", "thriller", "fantasy", "literature", "history", "travel"]
  subjects = ["nonfiction", "romance", "scifi", "horror", "mystery", "thriller", "fantasy", "literature", "history", "travel"]
  subjects.each do |subject|
    if File.exist?("db/data/genres/#{subject}.json")
      result = JSON.parse(File.read("db/data/genres/#{subject}.json"))
    else
      url_OL = "https://openlibrary.org/subjects/#{subject}.json?limit=#{limit}"
      result = JSON.parse(URI.open(url_OL).read)
      File.write("db/data/genres/#{subject}.json", JSON.pretty_generate(result))
    end
    p "Found #{result["works"].length} results for #{subject}"
    result["works"].each do |work|
      books << {
        title: work["title"],
        author: work["authors"].first.nil? ? "" : work["authors"].first["name"]
      }
    end
  end

  sleep 1

  books.each do |book|
    author = book[:author].dup
    title = book[:title].dup
    clean_author = ""
    clean_title = ""
    Encoding::Converter.new("utf-8", "ascii").primitive_convert(author, clean_author)
    Encoding::Converter.new("utf-8", "ascii").primitive_convert(title, clean_title)
    book_title_name = book[:title].gsub(" ", "_")
    if File.exist?("db/data/books/#{book_title_name}.json")
      result = JSON.parse(File.read("db/data/books/#{book_title_name}.json"))
    else
      url = "https://www.googleapis.com/books/v1/volumes?q=#{clean_author.gsub(" ", "+")} #{clean_title.gsub(" ", "+")}"
      result = JSON.parse(URI.open(url).read)
      File.write("db/data/books/#{book_title_name}.json", JSON.pretty_generate(result))
      sleep 5
    end
  end

  book_files = Dir.glob(Rails.root.join("db/data/books/*.json"))
  book_files.each do |file|
    book_file_result = JSON.parse(File.read(file))
    items = book_file_result["items"]
    firstitem = items[0]
    google_book = firstitem["volumeInfo"]
    book_title = google_book["title"]
    book_author = google_book["authors"][0]
    book_description = google_book["description"]
    book_links = google_book["imageLinks"]
    unless book_links.nil?
      book_image_link = book_links["smallThumbnail"]
    else
      book_image_link = "https://img.freepik.com/free-photo/book-composition-with-open-book_23-2147690555.jpg?semt=ais_hybrid&w=740&q=80"
      # book_image_link = items[1]["volumeInfo"]["imageLinks"]["smallThumbnail"]
    end
    Book.create(title: book_title, author: book_author, description: book_description, image_link: book_image_link)
  end
end

def generate_from_faker
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
end

seed_from_apis
