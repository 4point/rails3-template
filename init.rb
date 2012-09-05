#!/usr/bin/env ruby
# coding: utf-8

# clean file
run "rm README.rdoc"
run "rm -f public/index.html"
run "rm -f public/images/rails.png"
run "cp config/database.yml config/database.yml.example"

# add to Gemfile
append_file 'Gemfile', <<-CODE
gem "devise"
gem "kaminari"
gem "twitter-bootstrap-rails", :group => :assets
CODE

# bundle install
run 'bundle install'
run 'rails g devise:install'
run 'rails g bootstrap:install'
run 'rails g bootstrap:layout application fixed -f'

# default controller
run 'rails g controller welcome index'

# 改 route.rb 啟用 welcome/index
file_name = 'config/routes.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/# root :to => 'welcome#index'/, "root :to => 'welcome#index'")
File.open(file_name, 'w') {|file| file.puts ret}

# 改 layout
file_name = 'app/views/layouts/application.html.erb'
tmp = File.read(file_name)
ret = tmp.gsub(/<body>/, "<body>\n<p class='notice'><%= notice %></p>\n<p class='alert'><%= alert %></p>")
ret = ret.gsub(/<div class="navbar navbar-fixed-top">/, '<div class="navbar navbar-inverse navbar-fixed-top">')
File.open(file_name, 'w') {|file| file.puts ret}

# apply css
append_file 'app/assets/stylesheets/application.css', <<-CODE
p.alert { display: none }
CODE

# git init
git :init
git :add => '.'
git :commit => "-a -m 'init'"
