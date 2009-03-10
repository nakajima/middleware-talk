require 'rubygems'
require 'sinatra/base'

# For deploying to Heroku
class Talk < Sinatra::Base

  set :root, File.dirname(__FILE__)
  set :static, true

  get '/' do
    content_type 'text/plain'
    File.read(File.join(File.dirname(__FILE__), 'ideas.md'))
  end

end
