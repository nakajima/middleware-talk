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

# Rack Middleware

!SLIDE code

    use Rack::Auth::Basic do |*credentials|
      credentials == ['admin', 'sekret']
    end

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

# Middleware: A Definition

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

# Example:

### Web Framework Boilerplate

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

# Rack encourages good design

!SLIDE

## Single Responsibility Principle

!SLIDE

> Software entities (classes, modules functions, etc.) should be open for
> extension, but closed for modification.

!SLIDE definition

## Open-Closed Principle

!SLIDE

> There should never be more than one reason for a class to change.

!SLIDE

# Rack encourages re-use

!SLIDE

## Rack::NestedParams

!SLIDE

## Rack::MethodOverride

!SLIDE

# Rack encourages cool stuff

!SLIDE

## Rack::Cache

!SLIDE

## Rack::ESI

!SLIDE

## Rack::Unbasic

!SLIDE code

# JavaScript & Middleware

!SLIDE code javascript

<pre><span class="nx">on</span><span class="p">(</span><span class="s1">&#39;form.submitted&#39;</span><span class="p">)</span>
  <span class="p">.</span><span class="nx">use</span><span class="p">(</span><span class="nx">disableSubmit</span><span class="o">,</span> <span class="s1">&#39;form&#39;</span><span class="p">);</span>

<span class="nx">on</span><span class="p">(</span><span class="s1">&#39;click&#39;</span><span class="p">)</span>
  <span class="p">.</span><span class="nx">use</span><span class="p">(</span><span class="nx">flashFadeOut</span><span class="o">,</span> <span class="s1">&#39;.flash&#39;</span><span class="p">);</span>

<span class="nx">on</span><span class="p">(</span><span class="s1">&#39;keyup&#39;</span><span class="p">)</span> 
  <span class="p">.</span><span class="nx">use</span><span class="p">(</span><span class="nx">setTextStats</span><span class="o">,</span> <span class="s1">&#39;textarea&#39;</span><span class="p">);</span>
</pre>

!SLIDE

# Questions?
