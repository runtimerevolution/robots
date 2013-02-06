# Robots

Normally in Rails there is no good way to integrate a robots.txt per environment.
There is just one robots.txt for staging and production environment and we usually
want to have one robots.txt for staging and another for production. 

# Getting Started with Robots

### Robots Gem make your robots.txt files for you.

Robots is a DSL purposely made to generate diferent robots.txt files for different environments.

## Installation
```sh
gem 'robots'
```

## How to Use Robots?
For more information about how to build a correct robots.txt page check the [RFC Robots page](http://www.robotstxt.org/norobots-rfc.txt)
DSL Robots is easy to learn. You can split different allows and disallows by environment context.
First of all you have to write which links you want allow to crawl and those who doesnt.
You can create a rounting entry inside of routes.rb pointing to RobotsController:

```ruby
  get '/robots' => 'robots#robots', :as => :robots
```
And then create the controller itself:

```ruby
RobotsController < ApplicationController

  respond_to :txt

  def robots
  end

end
```
Afterwards create your robots file using Robots DSL:

```ruby
# inside of robots.robots
environment :production do
    allow do
       link "/posts"
       link "/members"
    end

    disallow do
       link "/admin"
       link "/categories"
    end
end

environment :staging do
  disallow do
    all
  end
end
```
The way to create a entry on robots file is just use `link` method:
```ruby
link "/users"
```
Or use a helper method `all` to explicit include all the urls of your site. 
Notice that method method `all` does not make sense in allow block, you can use it there
but it change nothing for the crawler prespective.

# ROADMAP:
- add oportunity to have different crawler specs for different user-agents
- add more test cases (Integration with Rails)

This project rocks and uses MIT-LICENSE.
