require 'rack'
require 'simple-app'

# A Rack app that will be protected.
SEKRET = proc { |env|
  [200, { 'Content-Type' => 'text/html' },
    'This is the sekret area.'
  ]
}

app = Rack::Builder.new do
  use Rack::CommonLogger

  # Dispatch requests to /sekret to SEKRET app
  map('/sekret') do
    # Using middleware for certain handlers
    use Rack::Auth::Basic do |user, pass|
      [user, pass] == ['admin', 'sekret']
    end
    
    run SEKRET
  end
  
  # Other requests fall through to SIMPLE app
  map('/') do
    run SIMPLE
  end
end

Rack::Handler::Mongrel.run app, :Port => 1235 if __FILE__ == $0