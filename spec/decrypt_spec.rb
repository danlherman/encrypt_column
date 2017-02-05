require 'spec_helper'
require 'encrypt_column/encrypt'
require 'active_support'

describe Decrypt do
  let(:plaintext) { 'plain text' }
  let(:good_key) { '9438290832459034095840398509809sdsfkl;kdsgfl;kdfsgsdsdlsad' }
  let(:wrong_key) { 'xxx9438290832459034095840398509809sdsfkl;' }
  let(:ciphertext) { Encrypt.text(plaintext) }

  context 'correct encryption key config specified' do

    subject { Decrypt.cipher(ciphertext) }

    before do
      ENV['ENCRYPTION_KEY'] = good_key
    end

    it 'returns the correct plaintext value' do
      expect(subject).to eq(plaintext)
    end
  end

  context 'wrong encryption key specified' do

    subject { Decrypt.cipher(ciphertext, wrong_key) }

    it 'return a wrong encryption key error' do
      expect(subject).to eq('ERROR: Wrong encryption key specified')
    end

  end
end

