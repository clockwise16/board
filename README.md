

# board 

### 제목과 내용 입력 가능한 게시판

* `redirect '/'`를 통해 `/create`로 이동없이 내용 저장 가능.

* `require 'sinatra/reloader'` : 자동으로 코드 변화를 Ruby 파일에 다시 바꿔준다.

* `require 'csv'` : Excel 형태의 csv 파일을 가져올 수 있게 해준다.

* `<<` : 배열의 끝에 더해주는 Method

  ```
  a = ["orange"]
  a << "apple"
  puts a
  
  => ["orange", "apple"] 
  ```

* CSV 파일에 정보 입력

  ```
  CSV.open("board.csv", "a+") do |csv|
      csv << [@title, @content]
  end
  ```

* Layout 사용 (`layout.erb `) : 기본 레이아웃 설정

  ```
  <body>
  	<%= yield %> # 이후 erb에서는 body 내용만 작성하면 기본 레이아웃 적용
  </body>
  ```

* 입력된 게시글 중 최신글 먼저 출력 (`index.erb`)

  ```
  <% @posts.reverse.each do |p| %>
      <p>제목 : <%= p[0] %><br>
         내용 : <%= p[1] %></p>
  <% end %>
  ```



***

# Data

### Board 게시판과 동일, CSV 대신 DB 이용

![data_mapper](https://user-images.githubusercontent.com/37928445/41496923-c07c3818-7185-11e8-9576-696979cbe47d.PNG)

* 홈페이지는 회원가입을 받아 로그인을 하는 구조를 가진다. 웹서비스에서는 회원가입을 받은 데이터를 Database서버에 저장하고 로그인을 할 때 로그인 정보가 Database에 있는지 확인 하는 과정을 거쳐 로그인이 된다. 여기서 Database를 SQLite3를 이용.

* `require 'data_mapper'` : sinatra와 Database간의 통신에 사용

  ```
  require 'data_mapper'
  # SQLite3를 이용해 data mapper를 구성하고 blog.db에 저장
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db") 
  
  # Define models
  class Post
    include DataMapper::Resource
    property :id, Serial				# An auto-increment integer key
    property :title, String			# A varchar type string, for short strings
    property :body, Text				# A text block, for longer string data.
    property :created_at, DateTime	 # A DateTime, for any date you might like.
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
  ```

*  **Bundler** : 필요한 gem의 정확한 버전을 추적하여 프로젝트에 일관된 환경을 제공, 

  * Bundler 설치

    ~~~ 
    $ gem install bundler
    $ bundle
    ~~~

  * `Gemfile` 작성 : 의존성 선언 파일

    ~~~
    source 'https://rubygems.org'	# Gem을 받아오는 서버 정의
    
    gem 'sinatra'
    gem 'sinatra-contrib'
    gem 'json', '~> 1.6'	# 버전을 명시적으로 지정 가능
    gem 'data_mapper'
    gem 'bcrypt'
    gem 'dm-sqlite-adapter'
    ~~~

  * bundle 안의 gem에 들어있는 실행 파일 실행

    ~~~
    $ bundle exec Ruby app.rb -o $IP
    ~~~

* 데이터베이스에 있는 모든 글(posts) 정보를 `Post` 모델로 반환하는 Method. 호출의 결과는 글(post)의 배열,  `@posts` 변수에 저장

  ```
  @posts = []
  @posts = Post.all
  ```

* 새로운 데이터 등록, /index에서 받은 정보를 `Post`의 title과 body에 작성 (해쉬 형태와 같다)

      @title = params[:title]
      @content = params[:content]
      
      Post.create(
          title: @title,
          body: @content
      )

* `each`  Method는 배열에 내장되어 있는 반복자. 배열의 원자 수 만큼 반복 (`index.erb`)

  ~~~
  <% @posts.each do |p| %>
      <p>제목 : <%= p.title %></p>
      <p>내용 : <%= p.body %></p>
  <% end %>
  ~~~

  
