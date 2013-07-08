require_relative '../issue'
describe Issue do
  it "parses the owner and name correctly" do
    raw = {
      "repository" => {
        "full_name" => "jackfranklin/test"
      },
      "created_at" => DateTime.now.to_s
    }
    issue = Issue.new(raw)
    expect(issue.owner).to eq "jackfranklin"
    expect(issue.name).to eq "test"
  end

end
