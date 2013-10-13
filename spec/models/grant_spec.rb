require "spec_helper"

describe Grant do
  it "is pending after creation" do
    grant = Grant.create!
    grant.should be_pending
  end

  it "cannot be funded after rejection" do
    grant = Grant.create!
    grant.reject
    grant.fund
    grant.should be_rejected
  end

  it "cannot be rejected if it is crowdfunding" do
    grant = Grant.create!
    grant.crowdfund
    grant.reject
    grant.should be_crowdfunding
  end

  it "can be saved if it is pending" do
    grant = Grant.create!
    grant.crowdfund
    grant.crowdfunding_failed
    grant.fund
    grant.should be_complete
  end
end
