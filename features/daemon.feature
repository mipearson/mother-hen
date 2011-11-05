Feature: Daemon

  Scenario: Daemon performing periodical checks
    Given that I have been configured to write a line to a file once a second
    And the file is empty
    When I run the daemon process
    And I wait '5' seconds
    Then the file should now have approximately '5' lines
  