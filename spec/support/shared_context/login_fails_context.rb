# frozen_string_literal: true

RSpec.shared_examples("login fails") do |method, action|
  let!(:user_login) { create(:account, role: Account.roles[:user]) }

  it "login fails" do
    perform_action(method, action)

    expect(logged_in?).to(eq(false))
    expect(flash[:danger]).to(eq(I18n.t("sessions.mess_pls_login")))
    expect(response).to(redirect_to(login_path))
  end

  it "not admin" do
    log_in user_login

    perform_action(method, action)

    expect(current_account.admin?).to(eq(false))
    expect(flash[:danger]).to(eq(I18n.t("http_error.forbidden")))
    expect(response).to(redirect_to(login_path))
  end
end
