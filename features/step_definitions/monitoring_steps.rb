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
  @config_tempfile = Tempfile.new(%w{slimmonitor_config .rb})
  @config_tempfile.write <<-EOF
    host 'localhost', :services => [:dummy]

    service :dummy do
      local do
        raise "Halp" unless File.exist?("/tmp/a_dummy_service")
      end
    end
  EOF
  @config_tempfile.close
end

When /^I perform a check over that service$/ do
  ServiceCheckJob.new(:service => :dummy, :host => 'localhost').perform
end

Then /^the service should appear as 'OK' on the status page$/ do
  get '/'
end

Then /^I should receive no notification$/ do
  pending # express the regexp above with the code you wish you had
end

After do
  @config_tempfile.unlink if @config_tempfile
end
    