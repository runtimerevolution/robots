# Robots
[![Build Status](https://travis-ci.org/runtimerevolution/robots.png?branch=master)](https://travis-ci.org/runtimerevolution/robots)

Normally in Rails there is no good way to integrate a robots.txt per environment.
There is just one robots.txt for staging and production environment and we usually
want to have one robots.txt for staging and another for production.

# Getting Started with Robots

### Robots Gem make your robots.txt files for you.

Robots is a DSL purposely made to generate robots.txt files for different environments.

## Installation
```sh
gem 'robots', :git => 'https://github.com/runtimerevolution/robots.git'
```

## How to Use Robots?
For more information about how to build a correct robots.txt page check the [RFC Robots specification](http://www.robotstxt.org/norobots-rfc.txt)

DSL Robots is easy to learn. You can split different allows and disallows by environment context.
First of all you have to write what kind of links want allow to crawl and those who doesn't.
To start using Robots you have to create a rounting entry inside of routes.rb pointing to RobotsController:
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
Or use a helper method called `all` to explicit include all the urls of your site.
Notice that method `all` does not make sense in allow blocks. To know what to do
on these exceptional cases you also can read information on [robotstxt.org](http://www.robotstxt.org/)

## Insert some Ruby logic inside of your template
You can control programmatically what kind of URL's are shown
on robots.txt, this means that you can have ruby code inside of Robots DSL.

```ruby
environment :production do
   allow do
     if BlogMode.active?
       link "/blog"
     end
     link "/home"
     link "/about-us"
   end


   disallow do
     link "/admin"
     link "/categories"
   end
end
```
# Road Map:
- add oportunity to have more than one allow and disallow collections for different user-agents

# License
Copyright © 2013 [Runtime Revolution](http://www.runtime-revolution.com), released under the MIT license.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/fdc6753bef9fc3af71a9fe0d68aff773 "githalytics.com")](http://githalytics.com/runtimerevolution/robots)

