# frozen_string_literal: true

class Account < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  private_constant :VALID_EMAIL_REGEX

  before_save :downcase

  enum role: { admin: 1, user: 0 }, _default: :user

  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :products, through: :comments

  has_secure_password

  validates :name, presence: true, length: { maximum: Settings.DIGIT_50 }
  validates :email, presence: true, length: { maximum: Settings.DIGIT_255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, allow_nil: true

  private

  def downcase
    email.downcase!
  end
end
