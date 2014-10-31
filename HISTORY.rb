blogger2 ❯ rails new blogger
blogger2 ❯ cd blogger
blogger ❯ rails s
blogger ❯ bin/rails generate model Article
    # # creates files:
    # # db/migrate/(some_time_stamp)_create_articles.rb
    #         A database migration to create the articles table
    # # app/models/article.rb
    #         The file that will hold the model code
    # # test/models/article_test.rb
    #         A file to hold unit tests for Article
    # test/fixtures/articles.yml

subl .../blogger/db/migrate/20141028225011_create_articles.rb
# before changes:
    # class CreateArticles < ActiveRecord::Migration
    #   def change
    #     create_table :articles do |t|

    #       t.timestamps
    #     end
    #   end
    # end


#   change to:
    # class CreateArticles < ActiveRecord::Migration
    #   def change
    #     create_table :articles do |t|
    #       t.string :title
    #       t.text :body
    #       t.timestamps
    #     end
    #   end
    # end

blogger ❯ bin/rake db:migrate   ## update table

# LOOKING AT THE MODEL
#   debugging
blogger ❯ bin/rails console
> Time.now
> Article.all
> Article.new

2.1.3 :001 > Time.now
  => 2014-10-29 10:17:30 +1100
2.1.3 :002 > Article.all
    # Article Load (0.8ms)  SELECT "articles".* FROM "articles"
    => #<ActiveRecord::Relation []>
2.1.3 :003 > Article.new
    => #<Article id: nil, created_at: nil, updated_at: nil>

#   enter new article:
a = Article.new
a.title = "Sample Article Title"
a.body = "This is the text for my article, woo hoo!"
a.save
Article.all

cd .../config/routes.rb
#  change:
Rails.application.routes.draw do
end
#   to:
Rails.application.routes.draw do
  resources :articles
end

blogger ❯ rake routes
      Prefix Verb   URI Pattern                  Controller#Action
    articles GET    /articles(.:format)          articles#index
             POST   /articles(.:format)          articles#create
 new_article GET    /articles/new(.:format)      articles#new
edit_article GET    /articles/:id/edit(.:format) articles#edit
     article GET    /articles/:id(.:format)      articles#show
             PATCH  /articles/:id(.:format)      articles#update
             PUT    /articles/:id(.:format)      articles#update
             DELETE /articles/:id(.:format)      articles#destroy

blogger ❯ bin/rails generate controller articles


# The output shows that the generator created several files/folders for you:

# app/controllers/articles_controller.rb :
#         The controller file itself
# app/views/articles :
#         The directory to contain the controller’s view templates
# test/controllers/articles_controller_test.rb :
#         The controller’s unit tests file
# app/helpers/articles_helper.rb :
#         A helper file to assist with the views (discussed later)
# test/helpers/articles_helper_test.rb :
#         The helper’s unit test file
# app/assets/javascripts/articles.js.coffee :
#         A CoffeeScript file for this controller
# app/assets/stylesheets/articles.css.scss :
#         An SCSS stylesheet for this controller

cd .../app/controllers/articles_controller.rb
# add:
  def index
    @articles = Article.all
  end
  def show
    @article = Article.find(params[:id])
  end
  def new
    @article = Article.new
  end
  def create
    fail
  end


.../app/helpers/articles_helper.rb.
# add:
def article_params
  params.require(:article).permit(:title, :body)
end


mkdir app/views/articles/index.html.erb
# add:
<h1>All Articles</h1>

<ul id="articles">
  <% @articles.each do |article| %>
    <li>
<%= link_to article.title, article_path(article), class: 'article_title' %>
    </li>
  <% end %>
<%= link_to "Create a New Article", new_article_path, class: "new_article" %>
</ul>
#  other html attributes:
# <%= link_to article.title, article_path(article),
    # class: 'article_title', id: "article_#{article.id}" %>

# ADDING NAVIGATION TO THE INDEX
# NEW ARTICLE LINK

create .../app/views/articles/show.html.erb
<h1>
%= @article.title
<p>
%= @article.body
%= link_to "<< Back to Articles List", articles_path

# add stylesheet to :
app/assets/stylesheets/screen.css

# create:
new.html.erb
  <h1>Create a New Article</h1>
  <%= render partial: 'form' %>

create: .../app/views/articles/edit.html.erb
# <h1>Edit an Article</h1>
# <%= render partial: 'form' %>

create .../app/views/articles/_form.html.erb
  # <%= form_for(@article) do |f| %>
  # <ul>
#   <% @article.errors.full_messages.each do |error| %>
#     <li><%= error %></li>
#   <% end %>
#   </ul>
#   <p>
#     <%= f.label :title %><br />
#     <%= f.text_field :title %>
#   </p>
#   <p>
#     <%= f.label :body %><br />
#     <%= f.text_area :body %>
#   </p>
#   <p>
#     <%= f.submit %>
#   </p>
# <% end %>

# add










#     I2: ADDING COMMENTS
-------------------------


blogger ❯ bin/rails generate model Comment author_name:string body:text article:references
blogger ❯ bin/rake db:migrate

# add
.../app/models/article.rb
  class Article < ActiveRecord::Base
      has_many :comments
  end

# article has many comments
# comment belongs to article

> a = Article.first
> a.comments
> Comment.new
> a.comments.new
> a.comments

> c = a.comments.new
> c.author_name = "Daffy Duck"
> c.body = "I think this article is thhh-thhh-thupid!"
> c.save
> d = a.comments.create(author_name: "Chewbacca", body: "RAWR!")

> a.reload
> a.comments

# DISPLAYING COMMENTS FOR AN ARTICLE
create ..../app/views/articles/show.html.erb
  <h3>Comments</h3>
  <%= render partial: 'articles/comment', collection: @article.comments %>

create .../app/views/articles/_comment.html.erb
<div>
  <h4>Comment by <%= comment.author_name %></h4>
  <p class="comment"><%= comment.body %></p>
  </div>

create .../app/views/comments/                  #dir
create .../app/views/comments/_form.html.erb    #file
  <h3>Post a Comment</h3>
  <p>(Comment form will go here)</p>

#add to articles_controller.rb
  def show
    ....
  @comment = Comment.new
  @comment.article_id = @article.id


blogger ❯ bin/rails generate controller comments

addto /comments_controller.rb
def create
  @comment = Comment.new(comment_params)
  @comment.article_id = params[:article_id]

  @comment.save

  redirect_to article_path(@comment.article)
end

def comment_params
  params.require(:comment).permit(:author_name, :body)
end

# I3: TAGGING
