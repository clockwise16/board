require 'sinatra'
require 'sinatra/reloader'
require 'csv'
# require 'data_mapper'

# DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

# class Post
#   include DataMapper::Resource
#   property :id, Serial
#   property :title, String
#   property :body, Text
#   property :created_at, DateTime
# end

# # Perform basic sanity checks and initialize all relationships
# # Call this when you've defined all your models
# DataMapper.finalize

# # automatically create the post table
# Post.auto_upgrade!

get '/' do

  @posts = []
  CSV.foreach("board.csv") do |row|
      @posts << row
  end
  
  # @posts => [["홍석님","돌아와요ㅜㅜ"], ["종원님", "화이팅"]]
  erb :index
end

get '/create' do
  @title = params[:title]
  @content = params[:content]
  
  CSV.open("board.csv", "a+") do |csv|
    csv << [@title, @content]
  end
  
  # erb :create
  redirect '/'
end
