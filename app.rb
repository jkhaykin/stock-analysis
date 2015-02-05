require 'rubygems'
require 'open-uri'
require 'sinatra'
require 'nokogiri'
require 'sentimental'
require 'sinatra'
require 'json'
require 'httparty'
require 'simple-rss'


get '/' do
erb :index
end

get '/stocks' do

@data = Nokogiri::HTML(open("https://www.google.com/finance?q=#{params[:q]}"))

Sentimental.load_defaults
Sentimental.threshold = 2
@analyzer = Sentimental.new

erb :stocks
end

get '/stocks.json' do
content_type :json

@data = Nokogiri::HTML(open("https://www.google.com/finance?q=#{params[:q]}"))

Sentimental.load_defaults
Sentimental.threshold = 2
@analyzer = Sentimental.new

@data.css("#price-panel").each do |stock|
stock.css(".pr")
stock.css(".ch")
end

@rss = SimpleRSS.parse open("https://www.google.com/finance/company_news?q=#{params[:q]}&output=rss")
count = 0
@rss.items.each do |article|
article.link
article.title
@news = Nokogiri::HTML(open("#{article.link}", 'User-Agent' => 'firefox'))
@score = @analyzer.get_score "#{@news.css("p")}"
@sentiment = @analyzer.get_sentiment "#{@news.css("p")}"

{:score => @score}.to_json
{:sentiment => @sentiment}.to_json

hash = {:sentiment => "#{@analyzer.get_sentiment "#{@news.css("p")}"}"}
if hash[:sentiment].include?("positive")
count += 1	
elsif hash[:sentiment].include?("neutral")
count += 0
elsif hash[:sentiment].include?("negative")
count -= 1	
end
end
if count >= 7
"High sentiment, be careful"
elsif count >= 3 && count < 7
{ :decision => "Sentiment is at a good level. It may be a good time to buy"}.to_json
elsif count < 3
"Low sentiment. Do not buy!"
end

end

