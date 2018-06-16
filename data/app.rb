require 'sinatra'
require 'data_mapper'
# Database 파일 하나를 생성해서 사용할게. (setup)
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db") #현재 폴더에 blog.exel 파일을 만드는 것과 같다

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

class Member
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :major, String
  property :year, String
  property :phone_number, String
  property :email, String
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!
Member.auto_upgrade!

get '/' do
    @posts = []
    
    @posts = Post.all # 테이블 안의 모든 내용을 꺼내오는데 배열 안에 넣겠다
    
    # CSV.foreach("board.csv") do |row|
    #     @posts << row 
    # end
    
    erb :index
end


get '/create' do
    @title = params[:title]
    @content = params[:content]
    
    Post.create(
        title: @title,
        body: @content
    )
    
    # CSV.open('board.csv', 'a+') do |csv|
    #     csv << [@title, @content]
    # end
    redirect '/'
end

get '/register' do
    erb :register
end

get '/signup' do
    @name = params[:name]
    @major = params[:major]
    @year = params[:year]
    @phone_number = params[:phone_number]
    @email = params[:email]
    
    Member.create(
        name: @name,
        major: @major,
        year: @year,
        phone_number: @phone_number,
        email: @email
    )
    
    redirect '/register'
end

get '/list' do
    @members = Member.all
   erb :list 
end