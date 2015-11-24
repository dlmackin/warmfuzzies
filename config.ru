require 'sinatra'
require 'json'
require 'net/https'

module AnonTalk
  class Application < Sinatra::Base
    get '*' do

      erb <<-EOF
<!doctype html>
<html>
  <head>
    <title>AnonSlack @max</title>
  <head>
  <body style="width:100%;height:100%;overflow:hide;">
    <div style="display:table;margin:10px auto;">
    <form action='/' method=post>
      <textarea name="message" rows="24" cols="80"></textarea>
      <button style="display:block" type="submit" name="button">Submit</button>
    </form>
    </div>
  </body>
</html>
      EOF
    end

    @@slack_uri = URI.parse('https://hooks.slack.com/services/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')

    post '/' do
      req = Net::HTTP::Post.new(@@slack_uri.request_uri)
      req.set_form_data({
        "payload" => {
          "channel" => "@zach",
          "username" => "AnonTalk",
          "text" => @params["message"],
          "icon_emoji" => ":ghost:"
        }.to_json
      })
      http = Net::HTTP.new(@@slack_uri.host, @@slack_uri.port)
      http.use_ssl = true
      http.request(req)
      [200, {}, 'Message Posted!']
    end
  end
end

run AnonTalk::Application
