class Encrypt
  def self.text(plaintext)
    return raise 'Missing Encryption Key Config' if ENV['ENCRYPTION_KEY'].nil?
    ActiveSupport::MessageEncryptor.new(ENV['ENCRYPTION_KEY']).encrypt_and_sign(plaintext)
  end
end
