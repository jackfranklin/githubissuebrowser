require 'sinatra'
require 'github_api'
require 'yaml'
require 'json'
require 'stamp'

require_relative 'issue_wrapper'

def environment
  (ENV["ruby_env"] || :development).to_sym
end

def root_url
  if environment == :production
    ""
  else
    "http://localhost:4000"
  end
end

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
    begin
      @token = github.get_token(params[:code])
      redirect "/issues?token=#{@token.token}"
    rescue OAuth2::Error
      redirect "/"
    end
  else
    @auth_url = github.authorize_url :redirect_uri => "#{root_url}/auth", :scope => "repo"
    erb :index
  end
end

get "/issues" do
  @authed = auth_github(params[:token])
  @issues = @authed.issues.list :filter => "all", :state => "open", :auto_pagination => true
  @wrapper = process_filters(IssueWrapper.new(@issues), params)
  erb :main
end

def process_filters(wrap, params)
  no_filter = true
  if params[:owner] && params[:owner] != "all"
    no_filter = false
    wrap = wrap.filter_by_owner(params[:owner])
  end
  if params[:name] && params[:name] != "all"
    no_filter = false
    wrap = wrap.filter_by_name(params[:name])
  end
  if no_filter
    wrap = wrap.restore
  end
  wrap
end


get "/auth" do
  redirect "/?code=#{params[:code]}"
end

  # ["url", "labels_url", "comments_url", "events_url", "html_url", "id", "number", "title", "user", "labels", "state", "assignee", "milestone", "comments", "created_at", "updated_at", "closed_at", "repository", "body"]
