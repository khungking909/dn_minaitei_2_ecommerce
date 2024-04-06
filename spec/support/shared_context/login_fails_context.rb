# frozen_string_literal: true

RSpec.shared_examples("login fails") do |method, action|
  let!(:user_login) { create(:account, role: Account.roles[:user]) }

  it "login fails" do
    perform_action(method, action)

    expect(flash[:danger]).to(eq(I18n.t("sessions.mess_pls_login")))
    expect(response).to(redirect_to(new_account_session_path))
  end

  it "not admin" do
    sign_in user_login

    perform_action(method, action)

    result = controller.send(:current_account)
    expect(result.admin?).to(eq(false))
    expect(response).to(redirect_to("/403.html"))
  end
end
