require 'net/http'
require 'hpricot'
require 'open-uri'

class ParserController < ApplicationController
  def index
    url = params[:url]
    selector = params[:selector]
    return(render(:text => '')) if url.blank?
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host)
    path = uri.query.blank? ? (uri.path.blank? ? '/' : uri.path) : "#{uri.path}?#{uri.query}"
    resp, body = http.get2(path, {'User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'})
    return(render(:text => body)) if selector.blank?
    doc = Hpricot(body)
    render :text => (doc/selector).to_s
  end
end
