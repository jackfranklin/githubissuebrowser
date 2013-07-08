require_relative '../issue'
require_relative '../issue_wrapper'
describe IssueWrapper do
  before(:each) do
    raw = [{
      "repository" => {
        "full_name" => "jackfranklin/test"
      },
      "created_at" => DateTime.now.to_s
    },
    {
      "repository" => {
        "full_name" => "jackfranklin/test2"
      },
      "created_at" => DateTime.now.to_s
    },
    {
      "repository" => {
        "full_name" => "tester/repo1"
      },
      "created_at" => DateTime.now.to_s
    }]
    @wrap = IssueWrapper.new(raw)
  end
  describe "Initialising" do
    it "parses the raw issues" do
      expect(@wrap.issues.first.class).to eq(Issue)
      expect(@wrap.issues.length).to eq(3)
    end
    it "parses out owners" do
      expect(@wrap.owners).to eq(["jackfranklin", "tester"])
    end
    it "parses out names" do
      expect(@wrap.names).to eq(["test", "test2", "repo1"])
    end
  end

  describe "filtering by owner" do
    it "correctly filters" do
      @wrap.filter_by_owner("tester")
      expect(@wrap.issues.length).to eq(1)
      expect(@wrap.issues.first.name).to eq("repo1")
    end

    it "can restore all issues" do
      @wrap.filter_by_owner("tester")
      expect(@wrap.issues.length).to eq(1)
      @wrap.restore
      expect(@wrap.issues.length).to eq(3)
    end
  end

  describe "filtering by name" do
    it "correctly filters" do
      @wrap.filter_by_name("test")
      expect(@wrap.issues.length).to eq(1)
      expect(@wrap.issues.first.owner).to eq("jackfranklin")
    end
  end
end
