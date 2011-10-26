Feature: Monitoring

  @wip
  Scenario: Dummy service is working
    Given I have a dummy service running
    And that my configuration file is configured to check this dummy service
    When I perform a check over that service
    Then the service should appear as 'OK' on the status page
    And I should receive no notification
    
  Scenario: Dummy service stops working
    Given my dummy service is stopped
    And that my configuration file is configured to check this dummy service
    When I perform a check over that service
    Then the service should appear as 'OK' on the status page
    And I should receive a notification
    
    