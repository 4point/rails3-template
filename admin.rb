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
run 'cd app/controllers/; wget https://raw.github.com/pct/rails3-template/master/replace/application_controller.rb'

# use different layout for devise
run 'cd app/views/layouts/; wget https://raw.github.com/pct/rails3-template/master/replace/devise_layout.html.erb'

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
ret = tmp.gsub(/<div class="content">/, "<div class='content'>\n<% if flash[:notice] %><div class='alert alert-info'><%= notice %></div><% end %>\n<% if flash[:alert] %><div class='alert alert-warning'><%= alert %></div><% end %>")
ret = ret.gsub(/<div class="navbar navbar-fixed-top">/, '<div class="navbar navbar-inverse navbar-fixed-top">')
ret = ret.gsub(/<footer>/, "<hr />\n<footer>")
File.open(file_name, 'w') {|file| file.puts ret}

append_file 'app/views/welcome/index.html.erb', <<-CODE
<% if not admin_signed_in? %>
  <%= link_to "Sign in", new_session_path('admin') %>
<% else %>
  <%= link_to "Sign out", destroy_admin_session_path, :method => :delete %>
<% end %>
CODE

# devise layout
file_name = 'app/views/devise/sessions/new.html.erb'
tmp = File.read(file_name)
ret = tmp.gsub(/f.submit "Sign in"/, 'f.submit "Sign in", :class => "btn"')
File.open(file_name, 'w') {|file| file.puts ret}

file_name = 'app/views/devise/passwords/new.html.erb'
tmp = File.read(file_name)
ret = tmp.gsub(/f.submit "Send me reset password instructions"/, 'f.submit "Send me reset password instructions", :class => "btn"')
File.open(file_name, 'w') {|file| file.puts ret}

file_name = 'app/views/devise/passwords/edit.html.erb'
tmp = File.read(file_name)
ret = tmp.gsub(/f.submit "Change my password"/, 'f.submit "Change my password", :class => "btn"')
File.open(file_name, 'w') {|file| file.puts ret}

file_name = 'app/views/devise/confirmations/new.html.erb'
tmp = File.read(file_name)
ret = tmp.gsub(/f.submit "Resend confirmation instructions"/, 'f.submit "Resend confirmation instructions", :class => "btn"')
File.open(file_name, 'w') {|file| file.puts ret}

file_name = 'app/views/devise/registrations/edit.html.erb'
tmp = File.read(file_name)
ret = tmp.gsub(/f.submit "Update"/, 'f.submit "Update", :class => "btn"')
File.open(file_name, 'w') {|file| file.puts ret}

file_name = 'app/views/devise/registrations/new.html.erb'
tmp = File.read(file_name)
ret = tmp.gsub(/f.submit "Sign up"/, 'f.submit "Sign up", :class => "btn"')
File.open(file_name, 'w') {|file| file.puts ret}

file_name = 'app/views/devise/unlocks/new.html.erb'
tmp = File.read(file_name)
ret = tmp.gsub(/f.submit "Resend unlock instructions"/, 'f.submit "Resend unlock instructions", :class => "btn"')
File.open(file_name, 'w') {|file| file.puts ret}


# scaffold without scaffold.css
file_name = 'config/application.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/config.assets.version = '1.0'/, "config.assets.version = '1.0'\n    config.generators do |g|\n        g.stylesheets false\n    end")
File.open(file_name, 'w') {|file| file.puts ret}

# apply css
append_file 'app/assets/stylesheets/application.css', <<-CODE
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
