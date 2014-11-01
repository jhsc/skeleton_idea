#Rails + Angular + Postgres Stack
---
####Stack 1 Applicaiton -> Receta 

The following commands start the project Meal-Builder from scratch.
- Rails 4.16
- Ruby 2.1.3
- mealbuilder_gemset
- Angular (Frontend)
- Postgres DB

Setting up Rbenv Gemset
--------------
Create a new project folder. Create rbenv gemset, and install appropiate gems needed for project.
```sh
mkdir meal-builder && cd
rbenv gemset create 2.1.3 mealbuilder_gemset
echo "mealbuilder_gemset" > .rbenv-gemsets
echo "2.1.3" > .rbenv-version

#working inside project directory
rbenv gemset active
gem install bundler rails thin --no-rdoc --no-ri
rbenv rehash
# optional to view downloaded gems
rbenv gemset list
gem list
```

Setting up our Rails project
--------------
```sh
# Create new rails project[Skip test, bundle] use postgresql
rails new meal_builder -T -d postgresql --skip-bundle
#Move files ruby/gemset environment (. files) to new created project folder
cd meal-builder/meal_builder

```
####Modify Gemfile 
```ruby
source 'https://rubygems.org'
# ruby
ruby '2.1.3'

# rails
gem 'rails', '4.1.6'

# postgresql database
gem 'pg', '~> 0.17.1'

# Front end
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'coffee-rails', '~> 4.0.0'
# gem 'angular-rails-templates', '~> 0.1.3'

# Front end depency manager
gem 'bower-rails', '~> 0.8.3'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Server
# gem 'thin', '~> 1.6.3'

group :development, :test do
	# test
  gem 'rspec-rails', '~> 3.1.0'
 	gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker', '~> 1.4.3'

  # debugging/commenting
  gem 'pry-suite', '~> 1.2.0'
  gem 'annotate', '~> 2.6.5'
  gem 'awesome_print', '~> 1.2.0'
end

group :test do
  gem 'database_cleaner', '~> 1.3.0'
end
```

####Initialize git
```sh
git init
git remote add origin git@github.com:jhsantacruz/lunch_hub.git
git add .
git commit -m 'Initial application commit'
git status
git push -u origin master

```

####Bundle install
```sh
bundle install
rbenv rehash

```

Create Postgres user
--------------
mysql setup

```sh
mysql.server start 
mysql -u root -p
SHOW DATABASES;
CREATE DATABASE lunch_hub_development;
CREATE DATABASE lunch_hub_test;

GRANT ALL PRIVILEGES ON lunch_hub_development.*
TO 'lunch_hub'@'localhost'
IDENTIFIED BY '';

GRANT ALL PRIVILEGES ON lunch_hub_test.*
TO 'lunch_hub'@'localhost';

SHOW GRANTS FOR 'lunch_hub'@'localhost';
```
postgres setup

```sh
createuser -P -s -e lunch_hub
```

Edit database.yml
--------------
Configure database.

```yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: lunch_hub
  password:
  host: localhost

development:
  <<: *default
  database: lunch_hub_development

test:
  <<: *default
  database: lunch_hub_test

production:
  <<: *default
  database: lunch_hub_production
  username: lunch_hub
  password: <%= ENV['LUNCH_HUB_DATABASE_PASSWORD'] %>
```







Set up bower.json [Angular front end w/ rails assets pipeline]
--------------
Front end dependencies (.bower.json)
```javascript
{
  "name": "MealBuilder",
  "private": true,
  "ignore": [
    "**/.*",
    "node_modules",
    "bower_components",
    "test",
    "tests"
  ],
  "dependencies": {
    "lodash": "~2.4.1",
    "angular": "~1.2.22",
    "angular-ui-router": "~0.2.10",
    "restangular": "~1.4.0"
  }
}
```
Specify directory for js bower files (.bowerrc)
```javascript
{
  "directory": "vendor/assets/components"
}
```
Now you can run bower install and watch your components download.
```sh
bower install
```
In config/application.rb we must add
```ruby
require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MealBuilder
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
  end
end
```
 This will allow the asset pipeline to incorporate our Bower vendor components.
 
####Asset config
assets/javascripts/application.js
```javascript
/*
 ==== Standard ====
 = require jquery
 = require bootstrap

 ==== Angular ====
 = require angular

 ==== Angular Plugins ====
 = require lodash
 = require restangular
 = require angular-ui-router

 = require_self 
 = require angular-app/app
 = require_tree ./angular-app/templates
 = require_tree ./angular-app/modules
 = require_tree ./angular-app/filters
 = require_tree ./angular-app/directives
 = require_tree ./angular-app/models
 = require_tree ./angular-app/services
 = require_tree ./angular-app/controllers
 = require_tree .
 */
```
 This is the file that will load all of our scripts and bootstrap Angular.
 
 #### Stylesheet config
 stylesheets/applicaiton.scss
 
```css
/*
 *= require_tree .
 *= require_self
 */

@import "bootstrap";

form {
  padding: 15px;
}

.form-controls {
  margin-bottom: 10px;
}
```
 #### Setup main application html
 views/application.html.erb
 ```html
<!DOCTYPE html>
<html ng-app="mealbuilder">
	<head>
	  <title>Meal Builder</title>
	  <%= stylesheet_link_tag    'application', media: 'all' %>
	  <%= javascript_include_tag 'application' %>
	  <%= csrf_meta_tags %>
	</head>

	<body>
		<div ng-view>
	  	<%= yield %>
		</div>
	</body>
	
</html>
```
This will 'bootstrap' the Angular application.
 
Configure Rails to serve as an API only
--------------
Generic index page controller to be the root route (Will be empty)

controllers/application_controller.rb
```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    render text: "", layout: "application"
  end
end

```
Add new Route (empty controller action)
```ruby
Rails.application.routes.draw do

  # Catch all 
  get "*path", to: "application#index"
  root 'application#index'
end


```
This will redirect any paths not defined previously to our catch-all application#index action.

#####Rails API Setup
Create Base API controller which sets default respond to json
constollers/api/base_controller.rb
```ruby
class Api::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
end
```
It disables authenticity token checks and says that it only responds to json by default.