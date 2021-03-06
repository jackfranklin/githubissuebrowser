require_relative 'issue'

class IssueWrapper
  attr_reader :issues, :owners, :names
  def initialize(raw_issues)
    @issues = parse_issues(raw_issues)
    @all_issues = @issues
    @owners, @names = get_owner_name(raw_issues)
  end

  def filter_by_owner(text)
    @issues = @issues.select { |issue| issue.owner == text }
    self
  end

  def filtered?
    @all_issues.length != @issues.length
  end

  def filter_by_name(text)
    @issues = @issues.select { |issue| issue.name == text }
    self
  end

  def names_for_owner(owner)
    @all_issues.select { |issue| issue.owner == owner }.map { |issue|
      issue.name
    }.uniq
  end

  def owner_for_name(name)
    @all_issues.select { |issue| issue.name == name }.uniq.first.owner
  end

  def restore
    @issues = @all_issues
    self
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
