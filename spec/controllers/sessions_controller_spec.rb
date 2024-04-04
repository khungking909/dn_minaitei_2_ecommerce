# frozen_string_literal: true

# spec/controllers/sessions_controller_spec.rb
require "rails_helper"
require "support/shared_examples/login_examples"

RSpec.describe(SessionsController, type: :controller) do
  include SessionsHelper

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to(render_template(:new))
    end
  end

  describe "POST #create" do
    let(:account) { create(:account) }

    context "load account failed" do
      before do
        post :create, params: { session: { email: "non_existent_email@example.com", password: "password" } }
      end

      it "renders new template with error message" do
        expect(flash.now[:error]).to(eq(I18n.t("sessions.login_email_err")))
      end

      it "returns unprocessable_entity status and render template new" do
        expect(response).to(have_http_status(:unprocessable_entity))
        expect(response).to(render_template(:new))
      end
    end

    context "load account success but authenticate failed" do
      before do
        post :create, params: { session: { email: account.email, password: "incorrect_password" } }
      end

      it "renders new template with error message" do
        expect(flash.now[:error]).to(eq(I18n.t("sessions.login_password_err")))
      end

      it "returns unprocessable_entity status and render template new" do
        expect(response).to(have_http_status(:unprocessable_entity))
        expect(response).to(render_template(:new))
      end
    end

    context "login success" do
      before do
        post :create, params: { session: { email: account.email, password: account.password } }
      end

      it "logs in the account and redirects to root path" do
        expect(session[:account_id]).to(eq(account.id))
        expect(response).to(redirect_to(root_path))
      end
    end
  end

  describe "DELETE #destroy" do
    include_examples "login examples"

    it "logs out the current account and redirects to root path" do
      delete :destroy
      expect(session[:account_id]).to(be_nil)
      expect(response).to(redirect_to(root_path))
    end
  end
end
