require 'spec_helper'
require 'encrypt_column/encrypt'
require 'active_support'

describe Encrypt do
  let(:plaintext) { 'plain text' }

  subject { Encrypt.text(plaintext) }

  context 'encryption key config specified' do

    before do
      ENV['ENCRYPTION_KEY'] = '9438290832459034095840398509809sdsfkl;kdsgfl;kdfsgsdsdlsad'
    end

    it 'returns a encrypted value of a text string' do
      expect(subject).to be_truthy
    end
  end

  context 'too short encryption key specified' do
    before do
      ENV['ENCRYPTION_KEY'] = 'shortkey'
    end

    it 'return a encryption key too short error' do
      expect{subject}.to raise_error('key length too short')
    end

  end

  context 'encryption key config specified' do

    before do
      ENV['ENCRYPTION_KEY'] = nil
    end

    it 'return a encryption key missing config error' do
      expect{subject}.to raise_error('Missing Encryption Key Config')
    end
  end
end

