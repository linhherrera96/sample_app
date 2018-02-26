class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: {maximum: Settings.user.email_length},
    format: {with: VALID_EMAIL_REGEX}, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.user.password_length}
  validates :name, presence: true, length: {maximum: Settings.user.name_length}
  before_save{email.downcase!}
  has_secure_password
end
