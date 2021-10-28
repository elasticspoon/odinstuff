# spec/calculator_spec.rb
require './lib/calculator'

describe Calculator do
  describe '#add' do
    it 'returns the sum of two numbers' do
      expect(subject.add(5, 2)).to eql(7)
    end

    it 'returns the sum of more than two numbers' do
      expect(subject.add(2, 5, 7)).to eql(14)
    end
  end

  describe '#multiply' do
    it 'returns the product of 2 numbers' do
      expect(subject.multiply(2, -8)).to eql(-16)
    end

    it 'returns the product of 3 numbers' do
      expect(subject.multiply(2, 3, 4)).to eql(24)
    end
  end
end
