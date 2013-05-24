require 'sinatra'
require 'github_api'
require 'yaml'

def config
  @settings ||= YAML.load_file("config.yml")
end

def github
  @github ||= Github.new :client_id => config["client_id"], :client_secret => config["client_secret"]
end

def auth_github(token)
  @github_auth ||= Github.new :client_id => config["client_id"], :client_secret => config["client_secret"], :oauth_token => token
end

get "/" do
  if params[:code]
    @token = github.get_token(params[:code])
    @authed = auth_github(@token.token)
    @issues = @authed.issues.list :filter => "all", :state => "open"
    erb :main
  else
    @auth_url = github.authorize_url :redirect_uri => "http://localhost:4000/auth", :scope => "repo"
    erb :index
  end
end

get "/auth" do
  redirect "/?code=#{params[:code]}"
end

  # ["url", "labels_url", "comments_url", "events_url", "html_url", "id", "number", "title", "user", "labels", "state", "assignee", "milestone", "comments", "created_at", "updated_at", "closed_at", "repository", "body"]
