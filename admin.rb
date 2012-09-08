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
run 'rails g kaminari:config'
run 'rake db:migrate'

# add default admin account
append_file 'db/seeds.rb', <<-CODE
admins = Admin.create([{email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com'}])
CODE

run 'rake db:seed'

# default controller
run 'rails g controller welcome index'

# add auth to default app controller
run 'cd app/controllers/; wget -N https://raw.github.com/pct/rails3-template/master/replace/application_controller.rb'

# use different layout for devise
run 'cd app/views/layouts/; wget -N https://raw.github.com/pct/rails3-template/master/replace/devise_layout.html.erb'
run 'cd app/views/layouts/; wget -N https://raw.github.com/pct/rails3-template/master/replace/application.html.erb'

# 改 route.rb 啟用 welcome/index
file_name = 'config/routes.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/# root :to => 'welcome#index'/, "root :to => 'welcome#index'")
File.open(file_name, 'w') {|file| file.puts ret}

# kaminari per page 10
file_name = 'config/initializers/kaminari_config.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/# config.default_per_page = 25/, "config.default_per_page = 10")
File.open(file_name, 'w') {|file| file.puts ret}

# devise use :get to sign out
file_name = 'config/initializers/devise.rb'
tmp = File.read(file_name)
ret = tmp.gsub(/config.sign_out_via = :delete/, "config.sign_out_via = :get")
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

run ':> app/views/welcome/index.html.erb'
append_file 'app/views/welcome/index.html.erb', <<-CODE
<div class="hero-unit">
  <h1>Welcome#index</h1>
  <p>Find me in app/views/welcome/index.html.erb</p>
</div>
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

# fetch scaffold template
run 'mkdir -p lib/templates/erb/scaffold'
run 'cd lib/templates/erb/scaffold; wget -N https://raw.github.com/pct/rails3-template/master/lib/templates/erb/scaffold/_form.html.erb'
run 'cd lib/templates/erb/scaffold; wget -N https://raw.github.com/pct/rails3-template/master/lib/templates/erb/scaffold/edit.html.erb'
run 'cd lib/templates/erb/scaffold; wget -N https://raw.github.com/pct/rails3-template/master/lib/templates/erb/scaffold/new.html.erb'
run 'cd lib/templates/erb/scaffold; wget -N https://raw.github.com/pct/rails3-template/master/lib/templates/erb/scaffold/index.html.erb'
run 'cd lib/templates/erb/scaffold; wget -N https://raw.github.com/pct/rails3-template/master/lib/templates/erb/scaffold/show.html.erb'

# fetch scaffold controller with kaminari
run 'mkdir -p lib/templates/rails/scaffold_controller'
run 'cd lib/templates/rails/scaffold_controller; wget -N https://raw.github.com/pct/rails3-template/master/lib/templates/rails/scaffold_controller/controller.rb'

# fetch kaminari views
run 'mkdir -p app/views/kaminari'
run 'cd app/views/kaminari; wget -N https://raw.github.com/pct/rails3-template/master/replace/kaminari/_first_page.html.erb'
run 'cd app/views/kaminari; wget -N https://raw.github.com/pct/rails3-template/master/replace/kaminari/_gap.html.erb'
run 'cd app/views/kaminari; wget -N https://raw.github.com/pct/rails3-template/master/replace/kaminari/_last_page.html.erb'
run 'cd app/views/kaminari; wget -N https://raw.github.com/pct/rails3-template/master/replace/kaminari/_next_page.html.erb'
run 'cd app/views/kaminari; wget -N https://raw.github.com/pct/rails3-template/master/replace/kaminari/_page.html.erb'
run 'cd app/views/kaminari; wget -N https://raw.github.com/pct/rails3-template/master/replace/kaminari/_paginator.html.erb'
run 'cd app/views/kaminari; wget -N https://raw.github.com/pct/rails3-template/master/replace/kaminari/_prev_page.html.erb'

# git ignore
append_file '.gitignore', <<-CODE
*~
*.swp
CODE

# git init
git :init
git :add => '.'
git :commit => "-a -m 'init'"
