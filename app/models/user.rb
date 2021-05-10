class User < ApplicationRecord
  validates_uniqueness_of :email, :nickname

  has_secure_password
  has_secure_password :recovery_password, validations: false
end
