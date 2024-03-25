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
      let(:valid_params) do
        {
          account: {
            name: "Test User",
            email: "test@example.com",
            address: "123 Test Street",
            phone_number: "1234567890",
            password: "password",
            password_confirmation: "password"
          }
        }
      end

      before { post :create, params: valid_params }

      it "creates a new account" do
        expect(Account.last).to(have_attributes(
                                  name: "Test User",
                                  email: "test@example.com",
                                  address: "123 Test Street",
                                  phone_number: "1234567890"
                                )
                               )
      end

      it "redirects to root path" do
        expect(response).to(redirect_to(root_path))
      end

      it "shows flash success message" do
        expect(flash[:success]).to(eq(I18n.t("accounts.register_success")))
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) do
        {
          account: {
            name: "",
            email: "",
            address: "",
            phone_number: "",
            password: "",
            password_confirmation: ""
          }
        }
      end

      before { post :create, params: invalid_params }

      it "does not save the new account" do
        expect(assigns(:account).id).not_to(be_present)
      end

      it "re-renders the new method" do
        expect(response).to(render_template(:new, status: :unprocessable_entity))
      end
    end
  end
end
