require 'open-uri'
require 'nokogiri'
require 'json'

html = URI.open('https://www.freecycle.org/town/SuttonUK')
doc = Nokogiri::HTML.parse(html)

data = JSON.parse(doc.search('fc-data')[0][':data'])

posts = {}

data['posts'].each do |post|
  next if post['type']['name'] != 'OFFER'

  posts[post['id']] = {
    Item: post['subject'],
    Description: post['description'].gsub(/\R+/, ' ')
  }
end

File.open('posts.json', 'w') do |f|
  f.write(JSON.pretty_generate(posts))
end
