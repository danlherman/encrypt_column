require 'spec_helper'
require 'encrypt_column/hashed'

describe Hashed do
  let(:hashed_value) { Digest::SHA2.hexdigest('somesalt something') }
  subject { Hashed.val('something') }

  context 'hash salt config specified' do

    before do
      ENV['HASH_SALT'] = 'somesalt '
    end

    it 'returns a hashed value of a text string' do
      expect(subject).to eql(hashed_value)
    end

    it 'returns a mismatch hashed value using a bad salt' do
      ENV['HASH_SALT'] = 'badsalt '
      expect(subject).not_to eql(hashed_value)
    end
  end

  context 'no hash salt config specified' do

    before do
      ENV['HASH_SALT'] = nil
    end

    it 'return a hash salt missing config error' do
      expect{subject}.to raise_error('Missing Hash Salt Config')
    end
  end
end

