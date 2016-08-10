class Encrypt
  def text(plaintext)
    raise EncryptionKeyConfigMissingError unless ENCRYPT_COLUMN_CONFIG[:encryption_key].present?
    ActiveSupport::MessageEncryptor.new(ENCRYPT_COLUMN_CONFIG[:encryption_key]).encrypt_and_sign(plaintext)
  end
end
