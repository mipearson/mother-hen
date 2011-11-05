Feature: Service Checks

  Scenario: Dummy service is working
    Given I have a dummy service running
    And I have been configured to check this dummy service
    When I perform a check over that service
    Then the service should appear as "OK" on the status page
    And I should receive no notification

  Scenario: Dummy service stops working
    Given my dummy service is stopped
    And I have been configured to check this dummy service
    When I perform a check over that service
    Then the service should appear as "Failure" on the status page
    And I should receive a notification
    
    