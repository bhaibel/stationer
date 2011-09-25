require 'nokogiri'

require 'stationer/node'
require 'stationer/document'

class Stationer
  def self.process(string)
    Document.new(string).email
  end
end