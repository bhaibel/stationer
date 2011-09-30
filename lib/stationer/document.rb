require 'css_parser'

class Stationer
  class Document
    def initialize(string)
      @original = string
    end

    def email
      @email_doc = doc.dup

      # css = @email_doc.css('style').inject CSSParser::Parser.new do |parser, stylesheet|
      #   parser.add_block! style.inner_html.dup
      # end
      # raise css.to_s
      @email_doc.root.replace Node.new(@email_doc.root).convert

      @email_doc.to_s
    end
    
    def css
      @css = find_css
    end

  private
    def doc
      @doc ||= Nokogiri::HTML(@original)
    end

    def find_css
      @css = doc.css('style').inject(CssParser::Parser.new) do |parser, stylesheet|
        parser = parser.add_block! stylesheet.inner_html.dup
      end
    end

    # not referenced by anything now, but retaining in case it's useful when I start adding in true stylesheet support
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
end