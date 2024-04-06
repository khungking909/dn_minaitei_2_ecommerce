# frozen_string_literal: true

class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  enum role: { admin: 1, user: 0 }, _default: :user

  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :products, through: :comments

  validates :name, presence: true, length: { maximum: Settings.DIGIT_50 }
end
