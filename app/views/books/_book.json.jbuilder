json.extract! book, :id, :title, :description, :onwer, :created_at, :updated_at
json.url book_url(book, format: :json)
