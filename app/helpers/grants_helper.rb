module GrantsHelper
  def parse_embed(grant)
    video = grant.video
    video.split('=').last if video
  end

  def successful
    @grants = []
    Grant.complete_grants.each do |grant|
      if grant.previous_version.state == 'crowdfunding'
        @grants << grant
      end
    end
    return @grants
  end

  def unsuccessful
    @grants = []
    Grant.crowdpending_grants.each do |grant|
      if grant.previous_version.state == 'crowdfunding'
        @grants << grant
      end
    end
    Grant.rejected_grants.each do |grant|
      flag = grant.previous_version.previous_version
      if flag && flag.state == 'crowdfunding'
        @grants << grant
      end
    end
    return @grants
  end

  def accepted_school
    @count = []
    School.all.each do |school|
      @count << school.grants.accepted_grants.length
    end
    return @count.to_json
  end

  def rejected_school
    @count = []
    School.all.each do |school|
      @count << school.grants.rejected_grants.length
    end
    return @count.to_json
  end

  def accepted_subject
    @count = []
    Grant::SUBJECTS.each do |subject|
      @grants = Grant.accepted_grants.select { |grant| grant.subject_areas.include? subject }
      !@grants.nil? ? @count << @grants.length : @count << 0
    end
    return @count.to_json
  end

  def rejected_subject
    @count = []
    Grant::SUBJECTS.each do |subject|
      @grants = Grant.rejected_grants.select { |grant| grant.subject_areas.include? subject }
      !@grants.nil? ? @count << @grants.length : @count << 0
    end
    return @count.to_json
  end

  def successful_goal
    @count = []
    Grant.uniq.pluck(:total_budget).sort_by(&:to_i).each do |goal|
      @grants = successful.select { |grant| grant.total_budget == goal }
      !@grants.nil? ? @count << @grants.length : @count << 0
    end
    return @count.to_json
  end

  def unsuccessful_goal
    @count = []
    Grant.uniq.pluck(:total_budget).sort_by(&:to_i).each do |goal|
      @grants = unsuccessful.select { |grant| grant.total_budget == goal }
      !@grants.nil? ? @count << @grants.length : @count << 0
    end
    return @count.to_json
  end
end
