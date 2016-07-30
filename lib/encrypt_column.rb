require "encrypt_column/version"

module EncryptColumn
  extend ActiveSupport::Concern

  class_methods do
    # Encrypt any column with a hash (searchable: true) or conditionally (if: Proc)
    # also has a failsafe (failsafe: true) feature to write to different db column in
    # the database, i.e. <name>_ciphertext. This prevents users from accidentally
    # commenting out the encrypt declaration and reading/writing plaintext to the db.
    def encrypt(name, options = {})
      searchable = options[:searchable] || false
      encrypt_cond = options[:if] || proc { true }
      failsafe = options[:failsafe] || false
      column = name
      column = "#{name}_ciphertext" if failsafe
      hash_column = "#{name}_hash"

      # getter
      define_method(name) do
        return read_attribute(column) unless instance_eval(&encrypt_cond)
        decrypt_cipher(read_attribute(column))
      end

      # setter
      define_method("#{name}=") do |value|
        return write_attribute(column, value) unless instance_eval(&encrypt_cond)
        write_attribute(column, encrypt_text(value))
        write_attribute(hash_column, hashed_value(value)) if searchable
      end

      # search method when searchable specified
      define_singleton_method("with_#{name}") do |value|
        where(hash_column.to_sym => hashed_value(value))
      end if searchable
    end
  end

  def encrypt_text(plaintext)
    ActiveSupport::MessageEncryptor.new(ENCRYPT_COLUMN_CONFIG[:encryption_key]).encrypt_and_sign(plaintext)
  end

  def decrypt_cipher(ciphertext)
    ActiveSupport::MessageEncryptor.new(ENCRYPT_COLUMN_CONFIG[:encryption_key]).decrypt_and_verify(ciphertext)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    return ciphertext
  end

  def hashed_value(plaintext)
    return nil if plaintext.nil?
    Digest::SHA2.hexdigest(ENCRYPT_COLUMN_CONFIG[:hash_salt] + plaintext.to_s)
  end
end
