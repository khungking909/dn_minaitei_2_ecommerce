# frozen_string_literal: true

class Account < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  private_constant :VALID_EMAIL_REGEX

  attr_accessor :remember_token

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

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = Account.new_token
    update_column(:remember_digest, Account.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_column(:remember_digest, nil)
  end

  private

  def downcase
    email.downcase!
  end
end
