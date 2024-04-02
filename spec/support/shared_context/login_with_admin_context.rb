# frozen_string_literal: true

RSpec.shared_context("with a logged-in with admin") do |method, action|
  before do
    @admin = create(:account, role: Account.roles[:admin])
    log_in(@admin)
    @initial_count = Product.count
    perform_action(method, action)
  end

  it "logged successfully" do
    expect(logged_in?).to(eq(true))
  end

  it "is admin" do
    expect(current_account.admin?).to(eq(true))
  end
end
