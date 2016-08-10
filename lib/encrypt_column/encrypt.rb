class Encrypt
  def self.text(plaintext)
    return raise 'Missing Encryption Key Config' if ENV['encryption_key'].nil?
    ActiveSupport::MessageEncryptor.new(ENV['encryption_key']).encrypt_and_sign(plaintext)
  end
end
