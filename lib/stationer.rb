require 'nokogiri'

class Stationer
  def self.process(string)
    new(string).email
  end
  
  def initialize(string)
    @original = string
  end

  def email
    email_doc = doc.dup
    email_doc.css('p').each do |node|
      inline_css = node.attr("style").to_s
      font_attrs = ""
      font_attrs << css_to_font_attr(inline_css, "color", "color")
      font_attrs << css_to_font_attr(inline_css, "font-family", "face")
      
      node.inner_html = "<font #{font_attrs}>#{node.inner_html}</font>"
      node.remove_attribute("style")
    end
    email_doc.to_s
  end
  
private
  def doc
    @doc ||= Nokogiri::HTML(@original)
  end
  
  def css_to_font_attr(css, css_attr_name, font_attr_name)
    if match = css.match(/#{css_attr_name}:\s*(.+);?/)
      " #{font_attr_name}='#{match[1]}'"
    else
      ""
    end
  end
end