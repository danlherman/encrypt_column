require 'openssl'
class Decrypt
  def self.cipher(ciphertext, key = ENV['ENCRYPTION_KEY'])
    raise 'Encryption Key Config Missing' unless key.present?
    ActiveSupport::MessageEncryptor.new(key).decrypt_and_verify(ciphertext)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    return 'ERROR: Missing encryption ciphertext' if ciphertext.nil? || ciphertext.blank?
    return 'ERROR: Wrong encryption key specified'
  end

  def self.ciphertext(ciphertext, key = ENV['ENCRYPT_KEY'])
    raise 'Encryption Key Config Missing' unless key.present?
    return 'ERROR: Missing encryption ciphertext' if ciphertext.nil? || ciphertext.blank?
    enciphered, iv = ciphertext.split('--', 2).map { |part| part.unpack('m')[0] }
    decipher = OpenSSL::Cipher::AES256.new(:CBC)

    decipher.decrypt
    decipher.key = key
    decipher.iv = iv

    deciphered = decipher.update(enciphered)
    deciphered << decipher.final
  end
end
