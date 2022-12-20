require 'net/http'
require 'uri'
require 'json'
require "date"

# post リクエストを作成 
URL = URI.parse('http://challenge.z2o.cloud/challenges')
post_req = Net::HTTP::Post.new(URL.path)
post_req.set_form_data({"nickname" => "Masanao"})
# post送信と,レスポンス中のchallenge_idを取得
post_res = Net::HTTP.new(URL.host, URL.port).start { |http| http.request(post_req) }
challenge_id = JSON.parse(post_res.body)["id"]
actives_at = JSON.parse(post_res.body)["actives_at"]


# putリクエストにて連続チャレンジを開始する。
PUT_REQ = Net::HTTP::Put.new(URL.path)
PUT_REQ["X-Challenge-Id"] = challenge_id


def put_request(actives_at)
  # 現在時からの差分で、予定時間までの待ち時間を算出
  # actives_at(エポックミリ秒)

  waiting = actives_at - (Time.now.to_f * 1000).floor
  sleep waiting / 1000.0

  # putリクエストを送信しレスポンスから、結果と次回実行時間を取得
  put_res = Net::HTTP.new(URL.host, URL.port).start { |http| http.request(PUT_REQ) }
  p put_res.body
  actives_at = JSON.parse(put_res.body)["actives_at"]

  put_request(actives_at)
end

put_request(actives_at)




