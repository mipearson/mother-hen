Feature: Daemon

  Scenario: Daemon performing periodical
  Given that I have been configured to write a line to a file once a second
  And the file is empty
  When I run the daemon process
  And I wait '5' seconds
  Then the file should now have between '4' and '6' lines
  