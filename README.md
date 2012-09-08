# Rails3 Template

pct's rails3 template, modified from ihower's and other resources.

## Usage:

Frontend template:

    $ rails new YourAppName -m https://raw.github.com/pct/rails3-template/master/init.rb

Backend template:

    $ rails new YourAppName -m https://raw.github.com/pct/rails3-template/master/admin.rb
    
then you could just use rails scaffold to gen your CRUD files:

    $ rails g scaffold post title:string content:text


## Backend Screenshots

#### login page:
![login page](https://raw.github.com/pct/rails3-template/master/screenshots/login.png)

#### welcome page:
![welcome page](https://raw.github.com/pct/rails3-template/master/screenshots/login_success.png)

#### scaffold list:
![list page](https://raw.github.com/pct/rails3-template/master/screenshots/list.png)

#### scaffold view:
![view page](https://raw.github.com/pct/rails3-template/master/screenshots/view.png)


## TODO:

1. admin with devise and cancan
2. admin add CRUD log
3. admin change email and password

## Reference

1. https://github.com/gabetax/twitter-bootstrap-kaminari-views
2. https://github.com/ihower/rails3-app-template
3. http://twitter.github.com/bootstrap/
4. https://github.com/plataformatec/devise
