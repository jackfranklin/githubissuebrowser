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
  end

end
