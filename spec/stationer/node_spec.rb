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

    context "given a li tag" do
      context "with color set in inline css" do
        it 'returns a li node which has been converted to email-friendly format' do
          converted_node = Stationer::Node.new(
            Nokogiri::HTML("<li style='color: #232'>text</li>").css('li').first
          ).convert

          converted_node.should be_a Nokogiri::XML::Node
          converted_node.to_s.should include "<li><font color=\"#232\">text</font></li>"
        end
      end

      context "with font set in inline css" do
        it 'returns a paragraph node which has been converted to email-friendly format' do
          converted_node = Stationer::Node.new(
            Nokogiri::HTML("<li style='font-family: Arial'>text</li>").css('li').first
          ).convert

          converted_node.should be_a Nokogiri::XML::Node
          converted_node.to_s.should include "<li><font face=\"Arial\">text</font></li>"
        end
      end

      context "with multiple attributes set in inline css" do
        it 'returns a paragraph node which has been converted to email-friendly format' do
          converted_node = Stationer::Node.new(
            Nokogiri::HTML("<li style='color: #232; font-family: Arial'>text</li>").css('li').first
          ).convert
          s = converted_node.to_s

          converted_node.should be_a Nokogiri::XML::Node
          s.should match /<font.+face="Arial".*>/
          s.should match /<font.+color="#232".*>/
          s.should match /<li><font.+>text<\/font><\/li>/
        end
      end
    end
    
    context "given a ul tag" do
      context "with color set in inline css" do
        it 'returns a ul node which has been converted to email-friendly format' do
          converted_node = Stationer::Node.new(
            Nokogiri::HTML("<ul style='color: #456'><li>text</li><li>moretext</li></ul>").css('ul').first
          ).convert

          converted_node.should be_a Nokogiri::XML::Node
          converted_node.to_s.should match /<ul>\s*<li><font color="#456">text<\/font><\/li>\s*<li><font color="#456">moretext<\/font><\/li>\s*<\/ul>/
        end
      end

      context "with font set in inline css" do
        it 'returns a paragraph node which has been converted to email-friendly format' do
          converted_node = Stationer::Node.new(
            Nokogiri::HTML("<ul style='font-family: Arial, Helvetica, sans-serif'><li>text</li><li>moretext</li></ul>").css('ul').first
          ).convert

          converted_node.should be_a Nokogiri::XML::Node
          converted_node.to_s.should match /<ul>\n?<li><font face="Arial, Helvetica, sans-serif">text<\/font><\/li>\n?<li><font face="Arial, Helvetica, sans-serif">moretext<\/font><\/li>\n?<\/ul>/
        end
      end

      context "with multiple attributes set in inline css" do
        it 'returns a ul node which has been converted to email-friendly format' do
          converted_node = Stationer::Node.new(
            Nokogiri::HTML("<ul style='font-family: Arial, Helvetica, sans-serif; color: #232'><li>text</li><li>moretext</li></ul>").css('ul').first
          ).convert
          s = converted_node.to_s

          converted_node.should be_a Nokogiri::XML::Node
          s.should match /<font.+face="Arial, Helvetica, sans-serif".*>/
          s.should match /<font.+color="#232".*>/
          s.should match /<li><font.+>text<\/font><\/li>/
        end
      end
    end
  end
end