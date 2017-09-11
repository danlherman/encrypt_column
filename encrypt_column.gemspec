# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encrypt_column/version'

Gem::Specification.new do |spec|
  spec.name          = "encrypt_column"
  spec.version       = EncryptColumn::VERSION
  spec.authors       = ["Dan Herman"]
  spec.email         = ["dherman@intratechs.com"]

  spec.summary       = %q{Easily encrypt columns in your app conditionally and with hashed values for searching}
  spec.homepage      = "https://github.com/danlherman/encrypt_column"
  spec.license       = "MIT"
  s.post_install_message = %q{

  ##### WARNING #######
  New BREAKING encryption algorithm used in this version of encrypt_column.

  If this is not a new installation of encrypt_column, already encrypted
  data will need to be CONVERTED using:

  Decrypt.cipher(ciphertext, <old_encryption_key>)

  i.e.
  ssn = Decrypt.cipher(profile.ssn_ciphertext, ENV['ENCRYPTION_KEY'])
  profile.update_column('ssn' ssn)

  ####################

  }

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rubocop", "~> 0.47.1"
  spec.add_development_dependency "coveralls"

  spec.add_dependency "bcrypt", "~> 3.1"
  spec.add_dependency "activerecord"
  spec.add_dependency "activesupport"
end
