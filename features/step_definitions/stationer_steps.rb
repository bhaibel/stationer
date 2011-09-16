When /^Stationer processes the following string:$/ do |string|
  @processed_string = Stationer.process string
end

Then /^I should get:$/ do |string|
  @processed_string.should == string
end
