# frozen_string_literal: true

class Account < ApplicationRecord
  CONFIRMATION = "confirmation".freeze
  RESET_PASSWORD = "reset_password".freeze
  GOOGLE_ACCOUNT_PASSWORD = "google_account_password".freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :is_login_with_google

  after_create_commit :send_mail_if_login_with_google, if: :is_login_with_google

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable,
         :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  enum role: { user: 0, admin: 1, manager: 2 }, _default: :user

  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :products, through: :comments

  validates :name, presence: true, length: { maximum: Settings.DIGIT_50 }

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |account|
      account.email = auth.info.email
      account.is_login_with_google = true
      account.password = SecureRandom.hex(5)
      account.name = auth.info.name
      account.confirmed_at = Time.current
    end
  end

  def send_mail_if_login_with_google
    SendEmailGoogleOauthJob.perform_async(email, password, Account::GOOGLE_ACCOUNT_PASSWORD)
  end

  def send_confirmation_instructions
    SendEmailAccountJob.perform_async(id, confirmation_token, Account::CONFIRMATION)
  end

  def send_reconfirmation_instructions
    SendEmailAccountJob.perform_async(id, confirmation_token, Account::CONFIRMATION)
  end

  def send_reset_password_instructions
    token = set_reset_password_token
    SendEmailAccountJob.perform_async(id, token, Account::RESET_PASSWORD)
  end
end
