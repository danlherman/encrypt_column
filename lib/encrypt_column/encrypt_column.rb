module ClassMethods
  # Encrypt any column with a hash (searchable: true) or conditionally(if: Proc)
  # also has a failsafe (failsafe: true) feature to write to a different db column
  # in the database, i.e. <name>_ciphertext. This prevents users from accidentally
  # commenting out the encrypt declaration and reading/writing plaintext to the
  # database.
  def encrypt(name, options = {})
    searchable = options[:searchable] || false
    encrypt_cond = options[:if] || proc { true }
    failsafe = options[:failsafe] || false
    @@encrypt_column_key = options[:key] || ENV['ENCRYPT_KEY']
    @@hash_salt = options[:hash_salt] || ENV['HASH_SALT']
    column = name
    column = "#{name}_ciphertext" if failsafe
    hash_column = "#{name}_hash"

    # getter
    define_method(name) do
      return read_attribute(column) unless instance_eval(&encrypt_cond)
      Decrypt.ciphertext(read_attribute(column), @@encrypt_column_key)
    end

    # setter
    define_method("#{name}=") do |value|
      return write_attribute(column, value) unless instance_eval(&encrypt_cond)
      write_attribute(column, Encrypt.plaintext(value, @@encrypt_column_key))
      write_attribute(hash_column, Hashed.val(value, @@hash_salt)) if searchable
    end

    # search method when searchable specified
    define_singleton_method("with_#{name}") do |value|
      where(hash_column.to_sym => Hashed.val(value, @@hash_salt))
    end if searchable
  end
end
