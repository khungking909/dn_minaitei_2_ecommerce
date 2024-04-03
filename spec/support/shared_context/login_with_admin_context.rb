# frozen_string_literal: true

RSpec.shared_context("with a logged-in with admin") do |method, action|
  let!(:admin_login) { create(:account, role: Account.roles[:admin]) }

  before do
    log_in(admin_login)
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
