Given /^that I have been configured to write a line to a file once a second$/ do
  MHConfig.parse <<-EOF
    host 'localhost', :services => [:dummy]
    email 'mipearson@gmail.com'
    frequency 1.second

    service :dummy do
      local do |hostname|
        File.open('/tmp/a_dummy_service', 'a+') do |file|
          file.puts("hello")
        end
      end
    end
  EOF
end

Given /^the file is empty$/ do
  File.open('/tmp/a_dummy_service', 'w').close
  File.read('/tmp/a_dummy_service').should == ''
end

When /^I run the daemon process$/ do
  require Rails.root.join(*%w{lib mother_hen daemon})
  @daemon_thread = Thread.new do
    begin
      MotherHen::Daemon.start
    rescue => e
      $stderr.puts e.inspect
      $stderr.puts e.backtrace.join("\n")
    end      
  end
end

When /^I wait '(\d+)' seconds$/ do |duration|
  sleep(duration.to_i)
end

When /^I stop the daemon process$/ do
  @daemon_thread.kill
end

Then /^the file should now have approximately '(\d+)' lines$/ do |required_linecount|
  line_count = File.read('/tmp/a_dummy_service').split("\n").length
  line_count.should be_within(1).of(required_linecount.to_i)
end