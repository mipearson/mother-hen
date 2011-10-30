def safe_system *args
  ENV['RAILS_ENV'] = Rails.env
  system *args
  raise "#{args.join(' ')} failed with return code #{$?.to_i}" unless $? == 0
end

Given /^I have a dummy service running$/ do
  FileUtils.touch("/tmp/a_dummy_service")
  File.exist?("/tmp/a_dummy_service").should be_true
end

Given /^that my configuration file is configured to check this dummy service$/ do
  Configuration.parse <<-EOF
    host 'localhost', :services => [:dummy]

    service :dummy do
      local do |hostname|
        raise "Halp" unless File.exist?("/tmp/a_dummy_service")
      end
    end
  EOF
end

When /^I perform a check over that service$/ do
  @job = ServiceCheckJob.new(:service => :dummy, :host => 'localhost')
  @job.save
  @job.perform
end

Then /^the service should appear as 'OK' on the status page$/ do
  visit '/'
  # save_and_open_page
  find("section#status tr#job#{@job.id} td.status").should have_content('OK')
end

Then /^I should receive a notification$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should receive no notification$/ do
   ActionMailer::Base.deliveries.should be_empty
end

After do
  @config_tempfile.unlink if @config_tempfile
end
    