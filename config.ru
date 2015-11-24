require 'sinatra'
require 'json'
require 'net/http'

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
      Net::HTTP.post_form(@@slack_uri, {
        "payload" => {
          "channel" => "@max",
          "username" => "AnonTalk",
          "text" => @params["message"],
          "icon_emoji" => ":ghost:"
        }.to_json
      })
      [200, {}, 'Message Posted!']
    end
  end
end

run AnonTalk::Application
