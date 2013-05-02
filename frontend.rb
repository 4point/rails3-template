#!/usr/bin/env ruby
# coding: utf-8

# clean file
run "rm README.rdoc"
run "rm -f public/favicon.ico"
run "rm -f public/index.html"
run "rm -f public/images/rails.png"
run "cp config/database.yml config/database.yml.example"

# add to Gemfile
append_file 'Gemfile', <<-CODE
gem "kaminari"
gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"
gem "google-analytics-rails"
group :development do
  gem 'guard-livereload', require: false
end
CODE

# bundle install
run 'bundle install'
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
run 'cd app/views/layouts/; wget -N https://raw.github.com/pct/rails3-template/master/replace/application.html.erb'

# apply css
append_file 'app/assets/stylesheets/application.css', <<-CODE
p.alert { display: none }
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
