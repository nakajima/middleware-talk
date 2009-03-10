require 'rack'

# A totally simple Rack app. We're going to build on this.
SIMPLE = proc { |env|
  [200, { 'Content-Type' => 'text/html' },
    "You need to go to /sekret"
  ]
}

Rack::Handler::Mongrel.run SIMPLE, :Port => 1234 if __FILE__ == $0