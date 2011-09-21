require 'nokogiri'
require 'stationer/node'

class Stationer
  def self.process(string)
    new(string).email
  end
  
  def initialize(string)
    @original = string
  end

  def email
    @email_doc = doc.dup
    inline_css_to_font_tags_for_selector('p')
    inline_css_to_font_tags_for_selector('li')

    @email_doc.css('ul').each do |node|
      inline_css = node.attr("style").to_s
      font_attrs = ""
      font_attrs << css_to_font_attr(inline_css, "color", "color")
      font_attrs << css_to_font_attr(inline_css, "font-family", "face")
      
      node.css('li').each do |item|
        item.inner_html = "<font #{font_attrs}>#{item.inner_html}</font>"
      end
      node.remove_attribute("style")
    end

    
    @email_doc.to_s
  end
  
private
  def doc
    @doc ||= Nokogiri::HTML(@original)
  end

  def inline_css_to_font_tags_for_selector(selector)
    @email_doc.css(selector).each do |node|
      inline_css = node.attr("style").to_s
      font_attrs = ""
      font_attrs << css_to_font_attr(inline_css, "color", "color")
      font_attrs << css_to_font_attr(inline_css, "font-family", "face")
      
      node.inner_html = "<font #{font_attrs}>#{node.inner_html}</font>" if font_attrs.length > 0
      node.remove_attribute("style")
    end
  end
  
  def css_to_font_attr(css, css_attr_name, font_attr_name)
    if match = css.match(/#{css_attr_name}:\s*([^;]+)/)
      " #{font_attr_name}='#{match[1]}'"
    else
      ""
    end
  end
end