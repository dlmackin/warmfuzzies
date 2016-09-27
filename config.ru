require 'sinatra'
require 'json'
require 'net/https'

module AnonTalk
  class Application < Sinatra::Base
    configure do
      set :slack_token => ENV["SLACK_TOKEN"]
    end

    get '/:user' do

      erb <<-EOF
<!doctype html>
<html>
  <head>
  <title>AnonSlack #{params[:user]}</title>
  <head>
  <body style="width:100%;height:100%;overflow:hide;">
    <div style="display:table;margin:10px auto;">
    <form action='/' method=post>
      <textarea name="message" rows="24" cols="80"></textarea>
      <input type=hidden name=channel value="#{params[:user]}" />
      <button style="display:block" type="submit" name="button">Submit</button>
    </form>
    </div>
  </body>
</html>
      EOF
    end

    @@slack_uri = URI.parse('https://slack.com/api/chat.postMessage')

    post '/' do
      req = Net::HTTP::Post.new(@@slack_uri.request_uri)
      req.set_form_data({
          "token" => settings.slack_token,
          "channel" => "#fuzzies-sandbox",
          "username" => "WarmFuzzies",
          "text" => @params["message"],
          "icon_emoji" => ":tada:"
      })
      http = Net::HTTP.new(@@slack_uri.host, @@slack_uri.port)
      http.use_ssl = true
      resp = http.request(req)

      [200, {}, resp.body]
    end
  end
end

run AnonTalk::Application
