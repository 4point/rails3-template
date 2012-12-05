# Rails3 Template

pct's rails3 template, modified from ihower's and other resources.

## Usage:

#### Template for frontend only:
    $ rails new YourAppName -m https://raw.github.com/pct/rails3-template/master/frontend.rb

#### Template for backend only:
    $ rails new YourAppName -m https://raw.github.com/pct/rails3-template/master/backend.rb
    
and the scaffold command::

    $ rails g scaffold post title:string content:text
    $ rake db:migrate

#### Full Template (frontend and backend in one site domain):

    $ rails new YourAppName -m https://raw.github.com/pct/rails3-template/master/full.rb

and the scaffold command::

    $ rails g scaffold backend/post title:string content:text
    $ rake db:migrate

** The bad smell is all your MVC file must use `backend` prefix **


## Backend Screenshots

(rails new MyBlog -m https://raw.github.com/pct/rails3-template/master/full.rb)

#### frontend: /
![frontend](https://raw.github.com/pct/rails3-template/master/screenshots/frontend.png)

#### login page: /admins/sign_in 
![login](https://raw.github.com/pct/rails3-template/master/screenshots/login.png)

#### backend page: /backend
![backend](https://raw.github.com/pct/rails3-template/master/screenshots/login_success.png)

#### scaffold list: /backend/posts
![list](https://raw.github.com/pct/rails3-template/master/screenshots/list.png)

#### search results:
![search result](https://raw.github.com/pct/rails3-template/master/screenshots/filter.png)

#### scaffold view: /backend/posts/1
![view](https://raw.github.com/pct/rails3-template/master/screenshots/view.png)


## TODO:

1. admin add cancan
2. admin add CRUD log
3. admin change email and password

## Reference

1. https://github.com/gabetax/twitter-bootstrap-kaminari-views
2. https://github.com/ihower/rails3-app-template
3. http://twitter.github.com/bootstrap/
4. https://github.com/plataformatec/devise
5. https://github.com/ernie/ransack
