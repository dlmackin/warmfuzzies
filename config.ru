require 'sinatra'
require 'json'
require 'net/https'

module AnonTalk
  class Application < Sinatra::Base
    configure do
      set :slack_token => ENV["SLACK_TOKEN"]
    end

    get '/' do
      erb :praise
    end

    @@slack_uri = URI.parse('https://slack.com/api/chat.postMessage')

    post '/api/praise' do
      req = Net::HTTP::Post.new(@@slack_uri.request_uri)
      req.set_form_data({
        "token" => settings.slack_token,
        "channel" => "#dianatest",
        "username" => "WarmFuzzies",
        "text" => @params["message"],
        "icon_emoji" => ":tada:"
      })
      http = Net::HTTP.new(@@slack_uri.host, @@slack_uri.port)
      http.use_ssl = true
      response = JSON.parse(http.request(req).body)

      if response["ok"] then
        erb :post_submit, :locals => { :slack_response => response }
      else
        erb :post_submit_error, :locals => { :slack_response => response }
      end
    end
  end
end

run AnonTalk::Application
