class Stationer
  def self.process(string)
    new(string).email
  end
  
  def initialize(string)
    @original = string
  end

  def email
    true
  end
end