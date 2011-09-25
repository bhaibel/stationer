require 'nokogiri'

class Stationer
  class Node
    LOW_LEVEL_NODES = ["p", "li"]
    
    def initialize(a_node, options = {})
      @node = a_node
      @parent_font_attrs = options[:parent_font_attrs]
    end
    
    def font_attrs_as_string
      @font_attrs_as_string || find_font_attrs_as_string
    end
    
    def convert
      n = @node.dup
      if LOW_LEVEL_NODES.include?(n.name)
        if font_attrs_as_string.length > 0
          n.inner_html = "<font #{font_attrs_as_string}>#{n.inner_html}</font>"
        end
      elsif n.children.length > 0
        n.inner_html = n.children.inject("") do |html, child|
          html << Node.new(child, :parent_font_attrs => font_attrs).convert.to_s
        end
      end
      n.remove_attribute("style")
      n
    end
    
  private
    def find_font_attrs_as_string
      @font_attrs_as_string = font_attrs.inject("") do |result, (name, value)|
        result << " #{name}='#{value}'"
      end
    end
    
    def font_attrs
      @font_attrs ||= find_font_attrs
    end

    def find_font_attrs
      @font_attrs = @parent_font_attrs ? @parent_font_attrs.clone : {}
      @font_attrs.merge! css_to_font_attr(:inline_css, "color", "color")
      @font_attrs.merge! css_to_font_attr(:inline_css, "font-family", "face")
    end
    
    def inline_css
      @inline_css ||= @node.attr("style").to_s
    end

    def css_to_font_attr(css_source, css_attr_name, font_attr_name)
      if match = send(css_source).match(/#{css_attr_name}:\s*([^;]+)/)
        { font_attr_name => match[1] }
      else
        {}
      end
    end

    def css_to_font_attr_string(css_source, css_attr_name, font_attr_name)
      if match = send(css_source).match(/#{css_attr_name}:\s*([^;]+)/)
        " #{font_attr_name}='#{match[1]}'"
      else
        ""
      end
    end
  end
end