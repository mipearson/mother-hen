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

When /^I run my monitor$/ do
  safe_system Rails.root.join('script', 'monitor.rb').to_s, @config_tempfile.path
end

Then /^the service should appear as 'OK' on the status page$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should receive no notification$/ do
  pending # express the regexp above with the code you wish you had
end

After do
  @config_tempfile.unlink if @config_tempfile
end
    