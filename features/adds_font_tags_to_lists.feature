Feature: can add appropriate font tags to lists

  Scenario Outline: inline css within li tag
    When Stationer processes a "li" tag with "<inline_css>" set in  inline css
    Then the returned email should include a "li font<font_attrs>"

  Scenarios: inline css within li tag
    | inline_css  | font_attrs     |
    | color: #346 | [color='#346'] |
    | font-family: Arial, Helvetica, sans-serif | [face='Arial, Helvetica, sans-serif'] |
    | color: #346; font-family: Arial, Helvetica | [color='#346'][face='Arial, Helvetica'] |
    
  Scenario Outline: inline css within ul tag
    When Stationer processes a "ul" tag with "<inline_css>" set in inline css and a nested "li" tag
    Then the returned email should include a "ul li font<font_attrs>"

  Scenarios: inline css within ul tag
    | inline_css  | font_attrs     |
    | color: #346 | [color='#346'] |
    | font-family: Arial, Helvetica, sans-serif | [face='Arial, Helvetica, sans-serif'] |
    | color: #346; font-family: Arial, Helvetica | [color='#346'][face='Arial, Helvetica'] |
  
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
      Then the returned email should include a "ul li font[color='#346']"
      And the returned email should include a "ul li font[color='#530']"

    