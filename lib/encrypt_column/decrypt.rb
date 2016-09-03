class Decrypt
  def self.cipher(ciphertext, key = ENV['ENCRYPTION_KEY'])
    raise 'Encryption Key Config Missing' unless key.present?
    ActiveSupport::MessageEncryptor.new(key).decrypt_and_verify(ciphertext)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    return ciphertext
  end
end
