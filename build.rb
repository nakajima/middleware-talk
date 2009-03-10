require 'rubygems'
require 'albino'
require 'nokogiri'
require 'rdiscount'
require 'erb'

raw = File.read(File.dirname(__FILE__) + '/ideas.md')

@classes = []
raw.gsub!(/^!SLIDE\s*([a-z\s]*)$/) do |klass|
  @classes << klass.to_s.chomp
  "!SLIDE"
end

@slides =  raw.split(/^!SLIDE\s*([a-z\s]*)$/) \
  .reject { |line| line.empty? } \
  .map { |slide| RDiscount.new(slide).to_html } \
  .map do |slide| 
    doc = Nokogiri::HTML(slide)
    
    doc.search('pre code').each do |snippet|
      node = Nokogiri::HTML(Albino.new(snippet.text, :ruby).to_s).at('div')
      snippet.replace(node)
    end
    
    doc.at('body').children.to_s
  end

template = File.read(File.dirname(__FILE__) + '/template.erb')

puts ERB.new(template).result(binding)