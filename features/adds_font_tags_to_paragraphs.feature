Feature: can add appropriate font tags to paragraphs

  Scenario Outline: inline css within paragraph tag
    When Stationer processes a "p" tag with "<inline_css>" set in  inline css
    Then the returned email should include a "p font<font_attrs>"

  Scenarios: inline css within paragraph tag
    | inline_css  | font_attrs     |
    | color: #346 | [color='#346'] |
    | font-family: Arial, Helvetica, sans-serif | [face='Arial, Helvetica, sans-serif'] |
    | color: #346; font-family: Arial, Helvetica | [color='#346'][face='Arial, Helvetica'] |