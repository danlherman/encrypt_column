class Encrypt
  def self.text(plaintext, key = ENV['ENCRYPTION_KEY'])
    return raise 'Missing Encryption Key Config' if key.nil?
    ActiveSupport::MessageEncryptor.new(key).encrypt_and_sign(plaintext)
  end
end
