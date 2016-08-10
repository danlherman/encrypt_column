class Decrypt
  def cipher(ciphertext)
    raise EncryptionKeyConfigMissingError unless ENCRYPT_COLUMN_CONFIG[:encryption_key].present?
    ActiveSupport::MessageEncryptor.new(ENCRYPT_COLUMN_CONFIG[:encryption_key]).decrypt_and_verify(ciphertext)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    return ciphertext
  end
end
