require 'rack'
require 'nakajima' # for Object#tap
require 'auth-middleware'

# Custom middleware to turn any path in the response body
# into a link to that path
class PathLinker
  def initialize(app)
    @app = app
  end
  
  def call(env)
    status, headers, body = @app.call(env)
    url = Rack::Request.new(env).url
    body = body.to_s
    body.gsub! %r|/(\w+)|,
      '<a href="%s\1">\1</a>' % url
    [status, headers, body]
  end
end

# Mount the SEKRET and SIMPLE apps again, using the PathLinker middleware.
CUSTOM = Rack::Builder.new do
  use Rack::CommonLogger
  use PathLinker
  
  map '/sekret' do
    use Rack::Auth::Basic do |user, pass|
      [user, pass] == ['admin', 'sekret']
    end
    
    run SEKRET
  end
  
  map '/' do
    run SIMPLE
  end
end

Rack::Handler::Mongrel.run CUSTOM, :Port => 1236