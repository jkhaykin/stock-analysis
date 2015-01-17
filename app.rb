require 'rubygems'
require 'open-uri'
require 'sinatra'
require 'nokogiri'
require 'sentimental'
require 'sinatra'
require 'json'
require 'httparty'
require 'simple-rss'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE 

get '/' do
erb :index
end

get '/stocks' do
@json = HTTParty.get("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=#{params[:q]}&callback=YAHOO.Finance.SymbolSuggest.ssCallback")

@data = Nokogiri::HTML(open("https://www.google.com/finance?q=#{params[:q]}"))

Sentimental.load_defaults
Sentimental.threshold = 2
@analyzer = Sentimental.new

erb :stocks
end

post '/stocks' do
erb :index
end