# frozen_string_literal: true

RSpec.shared_examples("login examples") do
  let(:account) { create(:account) }
  before { sign_in(account) }

  it "logs in successfully" do
    expect(current_account).to(be_present)
  end
end
