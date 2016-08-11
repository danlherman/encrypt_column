require 'digest'

class Hashed
  def self.val(plaintext)
    return nil if plaintext.nil?
    return raise 'Missing Hash Salt Config' if ENV['hash_salt'].nil?
    Digest::SHA2.hexdigest(ENV['hash_salt'] + plaintext.to_s)
  end
end
