require 'spec_helper'

describe Stationer do
  describe '.process' do
    it 'takes a string' do
      Stationer.process("test")
    end
    
    it 'instantiates a new Document object' do
      Stationer::Document.
        should_receive(:new).
        with("test").
        and_return(double(Stationer::Document).as_null_object)
      Stationer.process("test")
    end
    
    it 'returns the string as processed by its Document instance' do
      instance = double(Stationer::Document).as_null_object
      instance.should_receive(:email).and_return("result")
      Stationer::Document.stub!(:new).and_return(instance)
      
      Stationer.process("test").should == "result"
    end
  end
end