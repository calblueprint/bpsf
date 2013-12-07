module GrantsHelper
  def parse_embed(grant)
    video = grant.video
    video.split('=').last if video
  end

  def successful
    @grants
    Grant.complete_grants.each do |grant|
      if grant.previous_version.state == 'crowdfunding'
        @grants.append(grant)
      end
    end
    return @grants
  end

  def unsuccessful
    @grants
    Grant.crowdpending_grants.each do |grant|
      if grant.previous_version.state == 'crowdfunding'
        @grants.append(grant)
      end
    end
    return @grants
  end
end
