require 'rspec'
require './lib/caesar_chiper'

RSpec.describe '#shift_letter' do
  context 'when char is lowercase' do
    it 'returns letter with small positive shift' do
      expect(shift_letter('a', 5)).to eql('f')
    end
    it 'returns letter with large positive shift' do
      expect(shift_letter('a', 505)).to eql('l')
    end
    it 'returns letter with small negative shift' do
      expect(shift_letter('a', -5)).to eql('v')
    end
    it 'returns letter with large negative shift' do
      expect(shift_letter('a', -505)).to eql('p')
    end
  end

  context 'when char is uppercase' do
    it 'returns letter with small positive shift' do
      expect(shift_letter('A', 5)).to eql('F')
    end
    it 'returns letter with large positive shift' do
      expect(shift_letter('A', 505)).to eql('L')
    end
    it 'returns letter with small negative shift' do
      expect(shift_letter('A', -5)).to eql('V')
    end
    it 'returns letter with large negative shift' do
      expect(shift_letter('A', -505)).to eql('P')
    end
  end

  context 'when invalid char given' do
    it 'returns space if given space' do
      expect(shift_letter(' ', -5)).to eql(' ')
    end

    it 'returns symbol if given symbol' do
      expect(shift_letter('^', -5)).to eql('^')
    end
  end
end
