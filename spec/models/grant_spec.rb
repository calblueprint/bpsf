require "spec_helper"

describe Grant do
  it "is pending after creating" do
    grant = Grant.create!
    grant.should be_pending
  end
end
