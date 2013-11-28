module GradeValidation
  def grade_format
    return if not grade_level
    nums = grade_level.split(/,\s*|-/)
    unless nums.all? { |num| num =~ /^([K1-9]|1[0-2])$/ }
      errors.add :grade_level, "is not formatted properly"
    end
  end
end
