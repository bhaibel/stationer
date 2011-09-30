require 'spec_helper'

describe Stationer::Document do
  describe '#email' do
    #need to figure out most efficient way to mock this.
    #relying on integration tests til I do.
    it "sends all the relevant nodes through Node#convert"
  end
  
  describe '#css' do
    context 'when given a single internal stylesheet' do
      let(:stylesheet) { "p {color: #920}" }
      let(:doc) { Nokogiri::HTML::Builder.new { |doc|
        doc.html { doc.head { doc.style stylesheet }}
      }.to_html }
      
      it 'returns a CssParser::Parser instance containing its styles' do
        parser = Stationer::Document.new(doc).css
        parser.should be_a CssParser::Parser
        parser.find('p').should == "color: #920"
      end
    end
  end
end