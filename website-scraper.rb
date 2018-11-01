# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for it's own reasons.
#
# $ ruby heroku-sinatra-app.rb
#
require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'net/http'
require 'open-uri'

configure :production do
end

# Quick test
get '/' do
  content_type :text
  uri = params[:url]
  selector = params[:selector]
  callback = params[:callback]
  unless uri.nil?
    url = URI::parse(uri.gsub(' ','+'))
    http = Net::HTTP.new(url.host)
    path = (url.query == '' || url.query.nil?) ? ((url.path == '' || url.path.nil?) ? '/' : url.path) : "#{url.path}?#{url.query}"
    resp, body = http.get2(path, {'User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'})
    return(body) if selector.nil?
    puts selector
    doc = Nokogiri::HTML(body)
    output = doc.css(selector).to_s
    return(output) if callback.nil?
    content_type :js
    return("#{callback}('#{output.gsub("'","\\'").gsub("\n",'\n')}')")
  end
  content_type :html
  haml :index
end
