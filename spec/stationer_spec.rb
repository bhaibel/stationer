require 'spec_helper'

describe Stationer do
  describe '.process' do
    it 'takes a string' do
      Stationer.process("test")
    end
    
    it 'instantiates a new Stationer object' do
      Stationer.
        should_receive(:new).
        with("test").
        and_return(double(Stationer).as_null_object)
      Stationer.process("test")
    end
    
    it 'returns the string as processed by its Stationer instance' do
      instance = double(Stationer)
      instance.should_receive(:email).and_return("result")
      Stationer.stub!(:new).and_return(instance)
      
      Stationer.process("test").should == "result"
    end
  end
  
  describe '#email' do    
    it "sends all the relevant nodes through Node#convert"
  end
end