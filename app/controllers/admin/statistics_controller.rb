# frozen_string_literal: true

class Admin::StatisticsController < Admin::AdminController
  def monthly_statistics
    @statistics = Order.statistical_product
  end
end
