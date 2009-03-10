require 'method-watcher'

class Application
  class Auth
    def self.call(sym)
      puts "Enter password:"
      if $stdin.gets.chomp == 'wycats'
        puts "OK"
      else
        raise ArgumentError, "What is this, merb?"
      end
    end
  end
  
  class Logger
    def self.call(sym)
      puts "[method-defined] #{sym.inspect}"
    end
  end
  
  def self.abuse(app, options={})
    pattern = options[:match] || /.*/
    observe(pattern) { |sym| app.call(sym) }
  end
  
  abuse Auth, :match => /_.*/
  abuse Logger, :match => /.*/
  
  def _hello
    "World!"
  end
end

puts Application.new._hello