module Robots
  class DSL
    # Initializes a Robots DSL with some default variables
    # just like the "global" scope. Global Scope is used when
    # we want a same allow/disallow behaviour for different environments
    # For Example:
    #   environment :production do
    #      allow do
    #        link '/comments'
    #      end
    #   end
    #
    #   disallow do
    #      all
    #   end
    # receives +source+ as parameter which is a
    # peice of code in string format
    def initialize(source)
      create_schema_for("global")
      instance_eval(source) unless source.nil?
    end

    # environment computes a array with all
    # routes (allowed and disallowed) for its context
    # receives a +env_name+ which is the name of
    # environment to take
    def environment(env_name, &block)
      @_env = env_name
      create_schema_for(env_name)
      instance_eval(&block) if block_given?
    end

    # helper function used inside of allow or disallow context
    # receives a +url+ which is a string representing the url
    # that we want to mark
    def link(url)
      if @_bucket.nil?
        raise "Robots.link must be called inside of allow or disallow block"
      else
        @_bucket.push(url.to_s)
      end
    end

    # helper function used inside of allow or disallow context.
    # it represents all the avaliable routes that can be crawl
    # by search engines
    def all
      if @_bucket.nil?
        raise "Robots.all must be called inside of allow or disallow block"
      else
        @_bucket.push("/")
      end
    end

    # Allow block wraps all the links inside of this scope
    # with a allow context. The array created with be rendered
    # with allow robots syntax
    def allow(&block)
      collect_bucket(&block)
      scope = @_env.nil?? :global : @_env
      if @_bucket.any?
        @_allowed_routes[scope].push(@_bucket).flatten!
      end
      @_bucket = nil
    end

    # Disallow block wraps all the links inside of this scope
    # with a disallow context. The array created with be rendered
    # with disallow robots syntax
    def disallow(&block)
      collect_bucket(&block)
      scope = @_env.nil?? :global : @_env
      if @_bucket.any?
        @_disallowed_routes[scope].push(@_bucket).flatten!
      end
      @_bucket = nil
    end

    # Function responsible to format the output of Robots::DSL
    # it is used on Robots::TemplateHandler with a Rails.env variable
    # to contextualize what is the environment to be rendered
    # receives a +environment+ and returns a string with
    # robots.txt manifest well formatted
    def env(environment)
      robots_formated, scope = "User-agent: *\n", environment.to_sym
      unless empty_env_robots?(scope)
        robots_formated += print_routes(scope)
      else
        robots_formated += print_routes(:global)
      end
      robots_formated
    end

    private

    def collect_bucket(&block)
      @_bucket = []
      instance_eval &block
    end

    def print_routes(env)
      routes = ""
      @_allowed_routes[env].each do |route|
        routes += "Allow : #{route}\n"
      end

      @_disallowed_routes[env].each do |route|
        routes += "Disallow : #{route}\n"
      end
      routes
    end

    # checks if the +env+ passed by argument
    # has or not routes assigned to render
    def empty_env_robots?(env)
      @_allowed_routes[env] == [] and @_disallowed_routes[env] == []
    end

    def create_schema_for(environment)
      @_disallowed_routes ||= {}
      @_allowed_routes    ||= {}
      @_disallowed_routes.merge!({ environment.to_sym => [] })
      @_allowed_routes .merge!({ environment.to_sym => [] })
    end
  end
end
