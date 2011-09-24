When /^Stationer processes an email including the following string:$/ do |string|
  @processed_string = Stationer.process string
end

# Nokogiri is not responding to "doc.send tag_name", so let's just duplicate this mess for now.
When /^Stationer processes a "p" tag with "([^"]*)" set in  inline css$/ do |style|
  html = Nokogiri::HTML::Builder.new { |doc|
    doc.p "Sample text.", :style => style
  }.to_html
  @processed_string = Stationer.process(html)
end

When /^Stationer processes a "li" tag with "([^"]*)" set in  inline css$/ do |style|
  html = Nokogiri::HTML::Builder.new { |doc|
    doc.li "Sample text.", :style => style
  }.to_html
  @processed_string = Stationer.process(html)
end

When /^Stationer processes a "ul" tag with "([^"]*)" set in inline css and a nested "li" tag$/ do |style|
  html = Nokogiri::HTML::Builder.new { |doc|
    doc.ul(:style => style) {
      doc.li "Sample text."
    }
  }.to_html
  @processed_string = Stationer.process(html)
end


Then /^the returned email should include:$/ do |string|
  @processed_string.should match string.gsub(/\s+/, '\s*')
end
