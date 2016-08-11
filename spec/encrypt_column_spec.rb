require 'spec_helper'
require 'encrypt_column/encrypt'

describe EncryptColumn do
  let(:ssn) { '123456789' }
  before do
    ENV['encryption_key'] = '30924789032859043859034590834905843'
    ENV['hash_salt'] = 'some_salt'
    class SecureTable < ActiveRecord::Base
      encrypt :ssn, failsafe: true, searchable: true
      encrypt :card_number, if: -> (x) { x.card_type == 'credit' }
    end
  end

  context 'using the failsafe option' do

    it 'stores and gets the value using the ssn_ciphertext column' do
      subject = SecureTable.create(ssn: ssn)
      expect(subject.ssn_ciphertext).not_to be_nil
      expect(subject.ssn).to eql(ssn)
    end
  end

  context 'using the searchable option' do

    it 'retrieves a record using the hash value' do
      SecureTable.create(ssn: ssn)
      subject = SecureTable.with_ssn(ssn).first
      expect(subject).to be_instance_of(SecureTable)
    end
  end

  context 'using the conditional option' do

    it 'encrypts for credit card' do
      subject = SecureTable.create(
        card_type: 'credit',
        card_number: '4111111111111111'
      )
      expect(subject.card_number).not_to eql(subject[:card_number])
    end

    it 'does not encrypt for library card' do
      subject = SecureTable.create(
        card_number: '123456789',
        card_type: 'library'
      )
      expect(subject.card_number).to eql(subject[:card_number])
    end
  end

  it 'has a version number' do
    expect(EncryptColumn::VERSION).not_to be nil
  end
end

