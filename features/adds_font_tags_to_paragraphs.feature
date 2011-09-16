Feature: can add appropriate font tags to paragraphs

  Scenario: inline css within paragraph tag
    When Stationer processes the following string:
      """
      <p style="color: #346">
        Sample text.
      </p>
      """
    Then I should get:
      """
      <p><font color="#346">
        Sample text.
      </font></p>
      """