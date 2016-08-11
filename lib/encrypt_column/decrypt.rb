class Decrypt
  def self.cipher(ciphertext)
    raise EncryptionKeyConfigMissingError unless ENV['encryption_key'].present?
    ActiveSupport::MessageEncryptor.new(ENV['encryption_key']).decrypt_and_verify(ciphertext)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    return ciphertext
  end
end
