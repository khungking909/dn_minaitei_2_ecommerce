# frozen_string_literal: true

module StatisticsHelper
  def total_price_monthly_statistic(statistic_detail)
    statistic_detail.reduce(0) { |sum, value| sum + value.product_total_price }
  end

  def percent_of(total, product_price)
    (Float(product_price) / Float(total)) * 100
  end
end
