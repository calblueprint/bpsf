set :output, "#{path}/log/cron.log"
job_type :script, "'#{path}/script/:task' :output"

every 1.day, :at => '1:00 am' do
  runner "Grant.grant_ending"
end
