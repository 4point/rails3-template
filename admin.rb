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
run 'rails g devise Admin'
run 'rails g devise:views'
run 'rails g bootstrap:install'
run 'rails g bootstrap:layout application fixed -f'
run 'rake db:migrate'

# add default admin account
append_file 'db/seeds.rb', <<-CODE
admins = Admin.create([{email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com'}])
CODE

run 'rake db:seed'

# default controller
run 'rails g controller welcome index'

# add auth to default app controller
file_name = 'app/controllers/application_controller.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/protect_from_forgery/, "  before_filter :authenticate_admin!\n  protect_from_forgery")
File.open(file_name, 'w') {|file| file.puts ret}

# 改 route.rb 啟用 welcome/index
file_name = 'config/routes.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/# root :to => 'welcome#index'/, "root :to => 'welcome#index'")
File.open(file_name, 'w') {|file| file.puts ret}

# cancel devise admin registration
file_name = 'app/models/admin.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/devise :database_authenticatable, :registerable,/, "devise :database_authenticatable, #:registerable,")
File.open(file_name, 'w') {|file| file.puts ret}

file_name = 'config/routes.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/devise_for :admins/, "devise_for :admins, :skip => [:registration]")
File.open(file_name, 'w') {|file| file.puts ret}

# 改 layout
file_name = 'app/views/layouts/application.html.erb'
tmp = File.read(file_name)
ret = tmp.gsub(/<body>/, "<body>\n<p class='notice'><%= notice %></p>\n<p class='alert'><%= alert %></p>")
ret = ret.gsub(/<div class="navbar navbar-fixed-top">/, '<div class="navbar navbar-inverse navbar-fixed-top">')
File.open(file_name, 'w') {|file| file.puts ret}

append_file 'app/views/welcome/index.html.erb', <<-CODE
<% if not admin_signed_in? %>
  <%= link_to "Sign in", new_session_path('admin') %>
<% else %>
  <%= link_to "Sign out", destroy_admin_session_path, :method => :delete %>
<% end %>
CODE

# scaffold without scaffold.css
file_name = 'config/application.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/config.assets.version = '1.0'/, "config.assets.version = '1.0'\n    config.generators do |g|\n        g.stylesheets false\n    end")
File.open(file_name, 'w') {|file| file.puts ret}

# apply css
append_file 'app/assets/stylesheets/application.css', <<-CODE
p.alert { display: none; }
.span3 .sidebar-nav { display: none; }
input, textarea { width: auto; }
CODE

# git ignore
append_file '.gitignore', <<-CODE
*~
*.swp
CODE

# git init
git :init
git :add => '.'
git :commit => "-a -m 'init'"
