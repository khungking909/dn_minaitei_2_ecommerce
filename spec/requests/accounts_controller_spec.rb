# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AccountsController, type: :controller) do
  describe "GET #new" do
    before { get :new }

    it "assigns a new account to @account" do
      expect(assigns(:account)).to(be_a_new(Account))
    end

    it "renders the new template" do
      expect(response).to(render_template(:new))
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      before { post :create, params: { account: attributes_for(:account) } }

      it "creates a new account" do
        expect(assigns(:account).id).to(be_present)
      end

      it "redirects to root path" do
        expect(response).to(redirect_to(root_path))
      end

      it "shows flash success message" do
        expect(flash[:success]).to(eq(I18n.t("accounts.register_success")))
      end
    end

    context "with invalid attributes" do
      before do
        invalid_attributes = attributes_for(:account).merge(name: nil, email: "invalid_email", password: "123", password_confirmation: "123456")
        post :create, params: { account: invalid_attributes }
      end

      it "does not save the new account" do
        expect(assigns(:account).id).not_to(be_present)
      end

      it "re-renders the new method" do
        expect(response).to(render_template(:new, status: :unprocessable_entity))
      end
    end
  end
end
