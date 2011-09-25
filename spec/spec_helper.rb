require 'stationer'
require 'stationer/node'

def it_converts_to(name, selector)
  it "converts the node to email-friendly format" do
    converted_node = Stationer::Node.new(@original.css(name).first).convert
    converted_node.name.should == name
    converted_node.css(selector).length.should > 0
  end
end

def set_root_style(style)
  before do
    @original.css(@tag_name).first.set_attribute("style", style)
  end
end
