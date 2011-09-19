Feature: can add appropriate font tags to paragraphs

  Scenario: inline css color within paragraph tag
    When Stationer processes an email including the following string:
      """
      <p style="color: #346">
        Sample text.
      </p>
      """
    Then the returned email should include:
      """
      <p><font color="#346">
        Sample text.
      </font></p>
      """