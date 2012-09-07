# Rails3 Template

pct's rails3 template, modified from ihower's and other resources.

## Usage:

frontend template:

    $ rails new YourAppName -m https://raw.github.com/pct/rails3-template/master/init.rb

backend template:

    $ git clone https://github.com/pct/rails3-template.git
    $ rails new YourAppName -m rails3-template/master/admin.rb
    $ cp -rpf rails3-template/lib/template YourAppName/lib/

    and then just use normal CRUD:

    $ rails g scaffold post title:string content:text


## Backend Screenshots

####login page
![login page](https://raw.github.com/pct/rails3-template/master/screenshots/login.png)

####welcome page
![welcome page](https://raw.github.com/pct/rails3-template/master/screenshots/login_success.png)

####scaffold list
![list page](https://raw.github.com/pct/rails3-template/master/screenshots/list.png)

####scaffold view
![view page](https://raw.github.com/pct/rails3-template/master/screenshots/view.png)


## TODO:

1. admin with devise and cancan
2. admin add CRUD log
3. admin change email and password
