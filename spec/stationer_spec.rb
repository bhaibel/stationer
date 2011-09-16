require 'spec_helper'

describe Stationer do
  describe '.process' do
    it 'takes a string' do
      Stationer.process("test")
    end
    it 'instantiates a new Stationer object'
    it 'returns the string as processed by its Stationer instance'
  end
end