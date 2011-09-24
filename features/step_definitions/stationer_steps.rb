When /^Stationer processes an email including the following string:$/ do |string|
  @processed_string = Stationer.process string
end

Then /^the returned email should include:$/ do |string|
  @processed_string.should match string.gsub(/\s+/, '\s*')
end
