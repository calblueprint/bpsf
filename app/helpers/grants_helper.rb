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
    @count = [0,0,0,0,0,0,0,0,0,0,0]
    successful.each do |grant|
      @count[in_bucket(grant.crowdfunder.goal)] += 1
    end 
    return @count.to_json
  end

  def unsuccessful_goal
    @count = [0,0,0,0,0,0,0,0,0,0,0]
    unsuccessful.each do |grant|
      @count[in_bucket(grant.requested_funds)] += 1
    end 
    return @count.to_json
  end

  def in_bucket(goal)
    case goal
    when 0..99
      return 0
    when 100..199
      return 1
    when 200..299
      return 2
    when 300..399
      return 3
    when 400..499
      return 4
    when 500..599
      return 5
    when 600..699
      return 6
    when 700..799
      return 7
    when 800..899
      return 8
    when 900..999
      return 9
    when (goal >= 1000)
      return 10
    end
  end
end
