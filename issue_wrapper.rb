require_relative 'issue'

class IssueWrapper
  attr_reader :issues, :owners, :names
  def initialize(raw_issues)
    @issues = parse_issues(raw_issues)
    @owners, @names = get_owner_name(raw_issues)
  end

  def filter_by_owner(text)
    @issues.select { |issue| issue.owner == text }
  end

  private
  def parse_issues(issues)
    [].tap do |ary|
      issues.each do |issue|
        ary.push Issue.new(issue)
      end
    end
  end

  def get_owner_name(issues)
    owners = []
    titles = []
    issues.each do |repo|
      owner, title = repo["repository"]["full_name"].split("/")
      owners.push owner
      titles.push title
    end
    [owners.uniq, titles.uniq]
  end
end
