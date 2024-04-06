# frozen_string_literal: true

RSpec.shared_context("with a logged-in with admin") do |method, action|
  let!(:admin_login) { create(:account, role: Account.roles[:admin]) }

  before do
    sign_in(admin_login)
    @initial_count = Product.count
    perform_action(method, action)
  end

  it "logged successfully" do
    result = controller.send(:account_signed_in?)
    expect(result).to(eq(true))
  end

  it "is admin" do
    result = controller.send(:current_account)

    expect(result.admin?).to(eq(true))
  end
end
