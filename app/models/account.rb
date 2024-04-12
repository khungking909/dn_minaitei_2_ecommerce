# frozen_string_literal: true

class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :is_login_with_google

  after_commit :send_mail_if_login_with_google, if: :is_login_with_google

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
    GoogleAccountMailer.send_current_password(password, email).deliver_now
  end
end
