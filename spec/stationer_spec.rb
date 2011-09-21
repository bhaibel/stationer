require 'spec_helper'

describe Stationer do
  describe '.process' do
    it 'takes a string' do
      Stationer.process("test")
    end
    
    it 'instantiates a new Stationer object' do
      Stationer.
        should_receive(:new).
        with("test").
        and_return(double(Stationer).as_null_object)
      Stationer.process("test")
    end
    
    it 'returns the string as processed by its Stationer instance' do
      instance = double(Stationer)
      instance.should_receive(:email).and_return("result")
      Stationer.stub!(:new).and_return(instance)
      
      Stationer.process("test").should == "result"
    end
  end
  
  describe '#email' do
    it "replaces inline CSS colors in the original's <p> tags with font tags with color attributes" do
      s = Stationer.new "<p style='color: #ef3'>test</p>"
      s.email.should include "<p><font color=\"#ef3\">test</font></p>"
    end

    it "replaces inline CSS font-families in the original's <p> tags with font tags with font-face attributes" do
      s = Stationer.new "<p style='font-family: Arial, Helvetica, sans-serif'>test</p>"
      s.email.should include "<p><font face=\"Arial, Helvetica, sans-serif\">test</font></p>"
    end
    
    it "replaces inline CSS containing multiple CSS attributes with the appropriate font tags" do
      s = Stationer.new "<p style='font-family: Arial, Helvetica; color: #557329'>text</p>"
      s.email.should match /<font.+face="Arial, Helvetica".*>/
      s.email.should match /<font.+color="#557329".*>/
      s.email.should match /<p><font.+>text<\/font><\/p>/
    end
    
    it "replaces inline CSS with font tags in li tags" do
      s = Stationer.new "<li style='font-family: Arial, Helvetica; color: #557329'>text</li>"
      s.email.should match /<font.+face="Arial, Helvetica".*>/
      s.email.should match /<font.+color="#557329".*>/
      s.email.should match /<li><font.+>text<\/font><\/li>/
    end
    
    it "replaces inline CSS in ul tags with font tags within li tags" do
      s = Stationer.new "<ul style='font-family: Arial, Helvetica, sans-serif'><li>text</li><li>moretext</li></ul>"
      s.email.should match /<ul>\n<li><font face="Arial, Helvetica, sans-serif">text<\/font><\/li>\n<li><font face="Arial, Helvetica, sans-serif">moretext<\/font><\/li>\n<\/ul>/
    end
  end
end