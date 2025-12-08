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
require "net/http"

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

end

def make_csv_from_open_library
  books = []

  limit = 1000
  offset = 0
  # subjects = ["fantasy", "science fiction", "horror", "mystery", "thriller", "romance", "biography", "history", "travel", "food", "art", "music", "film", "tv", "theater", "dance", "fashion", "architecture", "design", "architecture", "design", "architecture", "design"]
  subjects = ["fantasy"]
  subjects.each do |subject|
    running = true
    while running
      url = "https://openlibrary.org/subjects/#{subject}.json?limit=#{limit}&offset=#{offset}"

      result = JSON.parse(URI.open(url).read)
      if result["works"].empty?
        running = false
      end
      result["works"].each do |work|
        books << {
          title: work["title"],
          author: work["authors"].first.nil? ? "" : work["authors"].first["name"],
          subject: work["subject"],
          url: "https://openlibrary.org/" + work["key"] + ".json"
        }
      end
      offset += limit
      puts "Offset: #{offset}"
      puts "Links: #{books.size}"
      puts "--------------------------------"
    end

    CSV.open("openlibrary_#{subject}.csv", "w") do |csv|
      csv << books.first.keys
      books.each do |book|
        csv << book.values
      end
    end
  end
end

def seed_from_openlib_gbooks_api
  puts "Creating Books"
  books = []

  limit = 25
  subjects = ["nonfiction", "romance", "scifi", "horror", "mystery", "thriller", "fantasy", "literature", "history", "travel"]
  subjects.each do |subject|
    if File.exist?("db/data/openlib_gbooks/genres/#{subject}.json")
      result = JSON.parse(File.read("db/data/openlib_gbooks/genres/#{subject}.json"))
    else
      url_OL = "https://openlibrary.org/subjects/#{subject}.json?limit=#{limit}"
      result = JSON.parse(URI.open(url_OL).read)
      File.write("db/data/openlib_gbooks/genres/#{subject}.json", JSON.pretty_generate(result))
      p "Found #{result["works"].length} results for #{subject}"
    end
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
    if File.exist?("db/data/openlib_gbooks/books/#{book_title_name}.json")
      result = JSON.parse(File.read("db/data/openlib_gbooks/books/#{book_title_name}.json"))
    else
      url = "https://www.googleapis.com/books/v1/volumes?q=#{clean_author.gsub(" ", "+")} #{clean_title.gsub(" ", "+")}"
      result = JSON.parse(URI.open(url).read)
      File.write("db/data/openlib_gbooks/books/#{book_title_name}.json", JSON.pretty_generate(result))
      sleep 5
    end
  end

  book_files = Dir.glob(Rails.root.join("db/data/openlib_gbooks/books/*.json"))
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
  puts "Books done!"
end

def make_jsons_from_hardcover_api
  # url for the api
  url = "https://api.hardcover.app/v1/graphql"

  # lists I want to download from
  list_ids = [83230, 96, 28242, 83400]
  list_ids.each do |list_id|

    # make the query using GraphQL lang, add the list_id
    query_string = <<~GRAPHQL
      query GetListBooks {
        lists(where: {id: {_eq: #{list_id}}}) {
          name
          books_count
          list_books {
            book {
              id
              title
              contributions {
                author {
                  name
                }
              }
              description
              images {
                url
              }
              taggings(limit: 10, distinct_on: tag_id) {
                tag {
                  tag
                }
              }
            }
          }
        }
      }
    GRAPHQL
    # convert the query into a hash
    query_hash = { query: query_string.strip } # 'variables: {}' can be added here to pass types safely
    # turn the hash into a JSON string
    query_json = JSON.generate(query_hash)

    # turn the api URL into a URI object, to be used in the post request
    uri = URI.parse(url)

    # make the request using Net::HTTP.post(uri, request_body(my query in json format), headers)
    response = Net::HTTP.post(
      uri,
      query_json,
      'Content-Type' => 'application/json',
      'Accept' => 'application/graphql-response+json', # Recommended header
      'Authorization' => HARDCOVER_KEY,
      'User-Agent' => 'BookwiseListFetcher/1.0 (Contact: zainab@zaisai.co.uk)'
    )

    # turn each list into a json
    result = JSON.parse(response.body)
    File.write("db/data/hardcover/lists/list_id_#{list_id}.json", JSON.pretty_generate(result))
  end

  # take each list.json and create all the book.json files
  list_files = Dir.glob(Rails.root.join("db/data/hardcover/lists/*.json"))
  list_files.each do |file|
    list_file_result = JSON.parse(File.read(file))
    list_books = list_file_result["data"]["lists"][0]["list_books"]
    list_books.each do |book|
      book_file_title = book["book"]["title"].gsub(/[\/\s]/, '_')
      unless File.exist?("db/data/hardcover/books/#{book_file_title}.json")
        File.write("db/data/hardcover/books/#{book_file_title}.json", JSON.pretty_generate(book))
      end
    end
  end
end

def seed_tags_hardcover_api
  puts "Creating Tags"
  book_files = Dir.glob(Rails.root.join("db/data/hardcover/books/*.json"))
  all_tags = []

  book_files.each do |file|
    book_file_result = JSON.parse(File.read(file))
    tags_array = book_file_result["book"]["taggings"]

    tags_array.each do |tag_node|
      tag_name = tag_node["tag"]["tag"].downcase
      unless all_tags.include?(tag_name)
        all_tags << tag_name
      end
    end
  end

  all_tags.each do |tag|
    Tag.create!(name: tag)
  end

  puts "Tags done!"
end

def seed_books_hardcover_api
  puts "Creating Books"

  book_files = Dir.glob(Rails.root.join("db/data/hardcover/books/*.json"))
  book_files.each do |file|
    book_file_result = JSON.parse(File.read(file))

    book_title = book_file_result["book"]["title"]
    book_author = book_file_result["book"]["contributions"][0]["author"]["name"]
    book_description = book_file_result["book"]["description"]
    book_image_link = book_file_result["book"]["images"][0]["url"]

    book_tags = []
    tags_array = book_file_result["book"]["taggings"]
    tags_array.each do |tag_node|
      tag_name = tag_node["tag"]["tag"].downcase
      unless book_tags.include?(tag_name)
        book_tags << tag_name
      end
    end

    new_book = Book.create!(title: book_title, author: book_author, description: book_description, image_link: book_image_link)
    book_tags.each do |book_tag|
      tag = BookTag.find_by(name: book_tag)
      BookTag.create!(book: new_book, tag: tag)
    end

  end

  puts "Books done!"
end

def create_user_with_books
  puts "Creating user..."
  user = User.create!(username: "booklover", email: "example@example.com", password: "password")

  puts "Creating user's shelves and books..."
  ["Fantastic Fantasy", "Untitled Shelf"].each do |shelf_name|
    shelf = Shelf.create!(user: user, name: shelf_name)
    (5..10).to_a.sample.times do
      user_book = UserBook.create!(book: Book.all.sample, user: user, status: ["read", "unread"].sample)
      ShelfBook.create!(shelf: shelf, user_book: user_book)
    end
  end

  puts "Done!"
end

# seed_tags_hardcover_api
seed_books_hardcover_api
create_user_with_books
