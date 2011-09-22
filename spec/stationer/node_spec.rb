require 'spec_helper'

describe Stationer::Node do
  it 'accepts a single Nokogiri::HTML::Node on initialization' do
    Stationer::Node.new(Nokogiri::HTML("<p>text</p>").root)
  end
  
  describe "#font_attrs_as_string" do
    context "given a paragraph tag" do
      it 'finds the correct font attributes for its contents based on inline CSS' do
        Stationer::Node.new(
          Nokogiri::HTML("<p style='color: #232'>text</p>").css('p')
        ).font_attrs_as_string.should == " color='#232'"
      end
    end
  end
  
  describe "#convert" do
    context "given a paragraph tag" do
      context "with color set in inline css" do
        it 'returns a paragraph node which has been converted to email-friendly format' do
          converted_node = Stationer::Node.new(
            Nokogiri::HTML("<p style='color: #232'>text</p>").css('p').first
          ).convert

          converted_node.should be_a Nokogiri::XML::Node
          converted_node.to_s.should include "<p><font color=\"#232\">text</font></p>"
        end
      end

      context "with font set in inline css" do
        it 'returns a paragraph node which has been converted to email-friendly format' do
          converted_node = Stationer::Node.new(
            Nokogiri::HTML("<p style='font-family: Arial'>text</p>").css('p').first
          ).convert

          converted_node.should be_a Nokogiri::XML::Node
          converted_node.to_s.should include "<p><font face=\"Arial\">text</font></p>"
        end
      end

      context "with multiple attributes set in inline css" do
        it 'returns a paragraph node which has been converted to email-friendly format' do
          converted_node = Stationer::Node.new(
            Nokogiri::HTML("<p style='color: #232; font-family: Arial'>text</p>").css('p').first
          ).convert
          s = converted_node.to_s

          converted_node.should be_a Nokogiri::XML::Node
          s.should match /<font.+face="Arial".*>/
          s.should match /<font.+color="#232".*>/
          s.should match /<p><font.+>text<\/font><\/p>/
        end
      end
    end
  end
end