require 'net/http'
require 'uri'
require 'json'
require "date"

URL = URI.parse('http://challenge.z2o.cloud/challenges')
def start_challenge
  post_req = Net::HTTP::Post.new(URL.path)
  post_req.set_form_data({"nickname" => "Masanao"})
  
  res = Net::HTTP.new(URL.host, URL.port).start { |http| http.request(post_req) }
  $challenge_id = JSON.parse(res.body)["id"]
  $actives_at = JSON.parse(res.body)["actives_at"]
end
start_challenge()

PUT_REQ = Net::HTTP::Put.new(URL.path)
PUT_REQ["X-Challenge-Id"] = $challenge_id
def put_request(actives_at)
  waiting_time = actives_at - (Time.now.to_f * 1000).floor
  sleep waiting_time / 1000.0
  put_res = Net::HTTP.new(URL.host, URL.port).start { |http| http.request(PUT_REQ) }
  p put_res.body
  actives_at = JSON.parse(put_res.body)["actives_at"]
  put_request(actives_at)
end
put_request($actives_at)