require 'rest_client'
require 'redis'
require_relative './../lib/redis/redisoptions'

class Event01

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
    @db_uuid = 10
    @job_url = 'http://localhost:4567/api/1.0/event/job-skills/'
  end

  def get_uuids
    @redisc.select @db_uuid
    @redisc.keys '*'
  end

  def get_urls
    arr = Array.new
    ['ios','android','java','python','ruby'].each do |job|
      myurl = @job_url + job
      arr.push(myurl)
    end
    arr
  end

  def get_data(url,uuid)
    response = RestClient.get url, :content_type => :json, :accept => :json, :access_token => uuid
  end
end

e01 = Event01.new
uuids = e01.get_uuids
urls = e01.get_urls
uuids.each do |uuid|
  print uuid; puts
  urls.each do |url|
    print url; puts
    response = e01.get_data(url,uuid)
    print response; puts; puts
  end
end
