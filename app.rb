require 'rubygems'
require 'open-uri'
require 'sinatra'
require 'nokogiri'
require 'sentimental'
require 'sinatra'
require 'json'
require 'httparty'
require 'simple-rss'
require 'rss'


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

