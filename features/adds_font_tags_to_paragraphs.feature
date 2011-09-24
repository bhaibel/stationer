Feature: can add appropriate font tags to paragraphs

  Scenario: inline css color within paragraph tag
    When Stationer processes a "p" tag with "color: #346" set in  inline css
    Then the returned email should include:
      """
      <p><font color="#346">
        Sample text.
      </font></p>
      """
  
  Scenario: inline css font within paragraph tag
    When Stationer processes a "p" tag with "font-family: Arial, Helvetica, sans-serif" set in  inline css
    Then the returned email should include:
      """
      <p><font face="Arial, Helvetica, sans-serif">
        Sample text.
      </font></p>
      """
      
  Scenario: inline css multiattribute within paragraph tag
    When Stationer processes a "p" tag with "color: #346; font-family: Arial, Helvetica" set in  inline css
    Then the returned email should include:
      """
      <p><font color="#346" face="Arial, Helvetica">
        Sample text.
      </font></p>
      """