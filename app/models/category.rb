# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[name id]
  end
end
