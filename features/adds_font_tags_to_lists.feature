Feature: can add appropriate font tags to lists

  Scenario: inline css color within li tag
    When Stationer processes an email including the following string:
      """
      <li style="color: #346">
        Sample text.
      </li>
      """
    Then the returned email should include:
      """
      <li><font color="#346">
        Sample text.
      </font></li>
      """
  
  Scenario: inline css font within li tag
    When Stationer processes an email including the following string:
      """
      <li style="font-family: Arial, Helvetica, sans-serif">
        Sample text.
      </li>
      """
    Then the returned email should include:
      """
      <li><font face="Arial, Helvetica, sans-serif">
        Sample text.
      </font></li>
      """
      
  Scenario: inline css multiattribute within li tag
    When Stationer processes an email including the following string:
      """
      <li style="color: #346; font-family: Arial, Helvetica">
        Sample text.
      </li>
      """
    Then the returned email should include:
      """
      <li><font color="#346" face="Arial, Helvetica">
        Sample text.
      </font></li>
      """
  
  Scenario: inline css color within ul tag
    When Stationer processes an email including the following string:
      """
      <ul style="color: #346">
        <li>
          Sample text.
        </li>
      </ul>
      """
    Then the returned email should include:
      """
      <ul>
        <li><font color="#346">
          Sample text.
        </font></li>
      </ul>
      """

  Scenario: inline css font within ul tag
    When Stationer processes an email including the following string:
      """
      <ul style="font-family: Arial, Helvetica, sans-serif">
        <li>
          Sample text.
        </li>
      </ul>
      """
    Then the returned email should include:
      """
      <ul>
        <li><font face="Arial, Helvetica, sans-serif">
          Sample text.
        </font></li>
      </ul>
      """

  Scenario: inline css multiattribute within ul tag
    When Stationer processes an email including the following string:
      """
      <ul style="color: #346; font-family: Arial, Helvetica">
        <li>
          Sample text.
        </li>
      </ul>
      """
    Then the returned email should include:
      """
      <ul>
        <li><font color="#346" face="Arial, Helvetica">
          Sample text.
        </font></li>
      </ul>
      """
  
  @wip
  Scenario: inline css color in li tag overrides inline css color set in parent ul
    When Stationer processes an email including the following string:
      """
      <ul style="color: #346">
        <li>
          Sample text.
        </li>
        <li style="color: #530">
          More text.
        </li>
      </ul>
      """
    Then the returned email should include:
      """
      <ul>
        <li><font color="#346">
          Sample text.
        </font></li>
        <li><font color="#530">
          More text.
        </font></li>
      </ul>
      """
    