require 'spec_helper'

describe EncryptColumn do
  let(:ssn) { '123456789' }
  before do
    # ENV['ENCRYPTION_KEY'] = '30924789032859043859034590834905843'
    ENV['ENCRYPT_KEY'] = 'f66de9e326b4a7defaa0b1e0f015b140'
    ENV['HASH_SALT'] = 'some_salt'
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

  context 'using the key option' do

    before do
      ENV['ENCRYPTION_KEY'] = nil
      class SecureTable < ActiveRecord::Base
        encrypt :ssn, failsafe: true,
                      key: 'some_encryption_key_specified_in_encrypt_declaration'
      end
    end

    it 'encrypts and decrypts' do
      subject = SecureTable.create(ssn: ssn)
      expect(subject.ssn).not_to eql(subject[:ssn])
      expect(subject.ssn).to eql(ssn)
    end
  end

  context 'using hash_salt option (no ENV var for HASH_SALT)' do
    before do
      ENV['HASH_SALT'] = nil
    end

    context 'with no hash salt specified' do
      before do
        class SecureTable < ActiveRecord::Base
          encrypt :ssn, searchable: true, failsafe: true
        end
      end

      it 'raises a missing hash salt error' do
        expect{SecureTable.create(ssn: 'something')}.to raise_error('Missing Hash Salt Config')
      end
    end

    context 'with hash salt specified inline' do
      before do
        class SecureTable < ActiveRecord::Base
          encrypt :ssn, searchable: true, failsafe: true, hash_salt: 'optionsalt '
        end
      end

      it 'returns a hashed value' do
        hashed_value = Digest::SHA2.hexdigest('optionsalt something')
        subject = SecureTable.create(ssn: 'something')
        expect(subject.ssn_hash).to eql(hashed_value)
      end

    end
  end

  it 'has a version number' do
    expect(EncryptColumn::VERSION).not_to be nil
  end
end
