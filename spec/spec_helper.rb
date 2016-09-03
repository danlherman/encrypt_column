$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'encrypt_column'
require 'sqlite3'
require 'active_record'
require 'coveralls'

Coveralls.wear!
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :secure_tables, :force => true do |t|
    t.string :ssn_hash
		t.string :ssn_ciphertext
    t.string :card_number
    t.string :card_type
  end
end
