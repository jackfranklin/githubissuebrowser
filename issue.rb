class Issue
  attr_reader :owner, :name, :number, :url, :title, :created_at

  def initialize(raw)
    @owner, @name = raw["repository"]["full_name"].split("/")
    @number = raw["number"]
    @url = raw["html_url"]
    @title = raw["title"]
    @created_at = DateTime.parse(raw["created_at"])
  end
end
