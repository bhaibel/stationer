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
    
    def self.it_converts_to(name, selector)
      it "converts the node to email-friendly format" do
        converted_node = Stationer::Node.new(@original.css(name).first).convert
        converted_node.name.should == name
        converted_node.css(selector).length.should > 0
      end
    end

    def self.set_root_style(style)
      before do
        @original.css(@tag_name).first.set_attribute("style", style)
      end
    end
    
    context "given a paragraph tag" do
      before do
        @tag_name = 'p'
        @original = Nokogiri::HTML("<p>text</p>")
      end
      
      context "with color set in inline css" do
        set_root_style 'color: #232'
        it_converts_to 'p', "font[color='#232']"
      end
      
      context "with font set in inline css" do
        set_root_style 'font-family: Arial, Helvetica'
        it_converts_to 'p', "font[face='Arial, Helvetica']"
      end
      
      context "with multiple attributes set in inline css" do
        set_root_style 'color: #232; font-family: Arial'
        it_converts_to 'p', "font[color='#232'][face='Arial']"
      end
    end

    context "given a li tag" do
      before do
        @tag_name = 'li'
        @original = Nokogiri::HTML("<li>text</li>")
      end

      context "with color set in inline css" do
        set_root_style 'color: #232'
        it_converts_to 'li', "font[color='#232']"
      end
      
      context "with font set in inline css" do
        set_root_style 'font-family: Arial, Helvetica'
        it_converts_to 'li', "font[face='Arial, Helvetica']"
      end
      
      context "with multiple attributes set in inline css" do
        set_root_style 'color: #232; font-family: Arial'
        it_converts_to 'li', "font[color='#232'][face='Arial']"
      end
    end
    
    context "given a ul tag" do
      before do
        @tag_name = 'ul'
        @original = Nokogiri::HTML("<ul><li>text</li><li>moretext</li></ul>")
      end

      context "with color set in inline css" do
        set_root_style 'color: #232'
        it_converts_to 'ul', "li font[color='#232']"
      end
      
      context "with font set in inline css" do
        set_root_style 'font-family: Arial, Helvetica'
        it_converts_to 'ul', "li font[face='Arial, Helvetica']"
      end
      
      context "with multiple attributes set in inline css" do
        set_root_style 'color: #232; font-family: Arial'
        it_converts_to 'ul', "li font[color='#232'][face='Arial']"
      end
      
      context "with a color inline-css style overriden by a child li's inline css" do
        before do
          @original.css('ul').first.set_attribute('style', "color: #232")
          @original.css('li').last.set_attribute('style', "color: #309")
        end
        
        it_converts_to 'ul', "li font[color='#232']"
        it_converts_to 'ul', "li font[color='#309']"
      end
      
      context "with a color inline-css style overriden by *first* child li's inline css" do
        before do
          @original.css('ul').first.set_attribute('style', "color: #232")
          @original.css('li').first.set_attribute('style', "color: #309")
        end
        
        it_converts_to 'ul', "li font[color='#232']"
        it_converts_to 'ul', "li font[color='#309']"
      end
    end
  
  end
end