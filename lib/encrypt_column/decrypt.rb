class Decrypt
  def self.cipher(ciphertext)
    raise 'Encryption Key Config Missing' unless ENV['ENCRYPTION_KEY'].present?
    ActiveSupport::MessageEncryptor.new(ENV['ENCRYPTION_KEY']).decrypt_and_verify(ciphertext)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    return ciphertext
  end
end
