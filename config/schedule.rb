set :output, "#{path}/log/cron.log"
job_type :script, "'#{path}/script/:task' :output"

every 1.day, :at => '9:49 pm' do
  runner "Grant.grant_ending"
end