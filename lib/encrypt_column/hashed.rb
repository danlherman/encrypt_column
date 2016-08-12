require 'digest'

class Hashed
  def self.val(plaintext)
    return nil if plaintext.nil?
    return raise 'Missing Hash Salt Config' if ENV['HASH_SALT'].nil?
    Digest::SHA2.hexdigest(ENV['HASH_SALT'] + plaintext.to_s)
  end
end
