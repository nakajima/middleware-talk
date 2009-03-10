!SLIDE
# The magical world of middleware

!SLIDE
# What's Rack?

!SLIDE code

    app = proc { |env|
      [200, {'Content-Type' => 'text/html'},
        'Welcome to the party.'
      ]
    }

!SLIDE code

    Rack::Handler::Mongrel.run(app)

!SLIDE
# What's Middleware

!SLIDE code

    use Rack::Auth::Basic do |*credentials|
      credentials == ['admin', 'sekret']
    end

!SLIDE
# Definition:

!SLIDE

> Middleware is software enterprise application integration.

<cite>- [Wikipedia](http://en.wikipedia.org/wiki/Middleware)</cite>

!SLIDE
# But seriously folks...

!SLIDE definition

> Middleware is an architecture-level application of the "compose method"
> pattern.

!SLIDE
## Compose Method

* Improves Communication
* Reduces Duplication
* More Expressive Code

!SLIDE
# Example

## Web Framework Boilerplate

!SLIDE
## As a method

!SLIDE code

    def respond_to_request(env)
      reload_if_development
      parse_nested_params(env)
      handle_http_verb_override(env)
      parse_cookies_for_session(env)
      # Whatever else web frameworks do
    end

!SLIDE
## As Rack middleware

!SLIDE code

    use Rack::Reloader
    use Rack::NestedParams
    use Rack::MethodOverride
    use Rack::Session::Cookie

!SLIDE

# How it works

!SLIDE code

    class AnyMiddleware
      def initialize(app)
        @app = app
      end
      
      def call(env)
        status, headers, body = @app.call(env)
      end
    end

!SLIDE

# Middleware is part of pipeline

!SLIDE code

    use AnyMiddleware

!SLIDE

# Middleware is called with `env`

!SLIDE

# Middleware performs pre-request actions (possibly)

!SLIDE code

    def call(env)
      env['any.middleware'] = 'Hello!'
      # other processing...
    end
    
!SLIDE

# Middleware either:

!SLIDE

## a) Returns a three element tuple to server handler. (DONE)

!SLIDE code

    def call(env)
      [200, { 'Content-Type' => 'text/plain' },
        "Sorry, that's as far as you go today."
      ]
    end

!SLIDE

## b) Calls its `@app`

!SLIDE code

    def call(env)
      @app.call(env)
    end

!SLIDE

# Middleware's app call returns three element tuple

!SLIDE code

    [302, { 'Location' => '/' },
      'You are being redirected'
    ]

!SLIDE

# Middleware performs post-request actions (possibly)

!SLIDE code

    def call(env)
      res = @app.call(env)
      cache(res) # caches or something
      res
    end

!SLIDE

# Write your own middleware

!SLIDE code

    class PathLinker
      def initialize(app)
        @app = app
      end
    end

!SLIDE code
  
    class PathLinker
      def call(env)
        status, headers, body = @app.call(env)
        url = Rack::Request.new(env).url
        body = body.to_s
        body.gsub! %r|/(\w+)|,
          '<a href="%s\1">\1</a>' % url
        [status, headers, body]
      end
    end

!SLIDE code
    
    # The three element tuple
    status, headers, body = @app.call(env)

!SLIDE code

    # Rack::Request gives you useful stuff
    url = Rack::Request.new(env).url

!SLIDE code

    # The body can be either a string or an array
    body = body.to_s

!SLIDE code

    # Replacing paths with links to paths
    body.gsub! %r|/(\w+)|, '<a href="%s\1">\1</a>' % url

!SLIDE code

    # Returning the new response
    [status, headers, body]

!SLIDE

# DEMO

!SLIDE demo

# [Simplest App](http://localhost:1234)

!SLIDE demo

# [Authorization Middleware](http://localhost:1235)

!SLIDE demo

# [Custom Path Link Middleware](http://localhost:1236)

!SLIDE

# Principles

!SLIDE
# Single Responsibility Principle

!SLIDE
> Software entities (classes, modules functions, etc.) should be open for
> extension, but closed for modification.

!SLIDE
# Open-Closed Principle

!SLIDE

> There should never be more than one reason for a class to change.

!SLIDE
# Examples of Rack Middleware

!SLIDE code

    Rack::MethodOverride
    Rack::Cache
    Rack::ESI
    Rack::Flash
    Rack::Unbasic

!SLIDE code

# Questions?