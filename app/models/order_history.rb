# frozen_string_literal: true

class OrderHistory < ApplicationRecord
  belongs_to :order
  belongs_to :product
end
