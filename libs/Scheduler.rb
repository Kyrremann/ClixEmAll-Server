scheduler = Rufus::Scheduler.new

scheduler.every '5m' do
  puts Time.now
end