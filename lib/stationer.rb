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
      if color_match = inline_css.match(/color:\s*(.+);?/)
        font_attrs << " color='#{color_match[1]}'"
      end
      if font_match = inline_css.match(/font-family:\s*(.+);?/)
        font_attrs << " face='#{font_match[1]}'"
      end
      node.inner_html = "<font #{font_attrs}>#{node.inner_html}</font>"
      node.remove_attribute("style")
    end
    email_doc.to_s
  end
  
private
  def doc
    @doc ||= Nokogiri::HTML(@original)
  end
end