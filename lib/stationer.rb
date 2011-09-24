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

    ['p', 'ul', 'li'].each do |selector|
      inline_css_to_font_tags_for_selector(selector)
    end
    
    @email_doc.to_s
  end
  
private
  def doc
    @doc ||= Nokogiri::HTML(@original)
  end

  def inline_css_to_font_tags_for_selector(selector)
    @email_doc.css(selector).each do |node|
      node.replace Node.new(node).convert
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