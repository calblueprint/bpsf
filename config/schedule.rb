set :output, "#{path}/log/cron.log"

every 1.day, :at => '1:00 am' do
  runner "Grant.grant_check"
  command "echo 'ran grant check'"
end

every :sunday, :at => '8:00 am' do
  runner "Recipient.weekly_digest"
  command "echo 'ran digest'"
end
