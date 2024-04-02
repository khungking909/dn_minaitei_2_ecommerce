# frozen_string_literal: true

RSpec.shared_examples("login fails") do |method, action|
  it "login fails" do
    perform_action(method, action)

    expect(logged_in?).to(eq(false))
    expect(flash[:danger]).to(eq(I18n.t("sessions.mess_pls_login")))
    expect(response).to(redirect_to(login_path))
  end

  it "not admin" do
    @user = create(:account, role: Account.roles[:user])
    log_in @user

    perform_action(method, action)

    expect(current_account.admin?).to(eq(false))
    expect(flash[:danger]).to(eq(I18n.t("http_error.forbidden")))
    expect(response).to(redirect_to(login_path))
  end
end
