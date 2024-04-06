# frozen_string_literal: true

# spec/controllers/accounts_controller_spec.rb

require "rails_helper"

RSpec.describe(AccountsController, type: :controller) do
  describe "#configure_permitted_parameters" do
    it "permits the specified parameters for sign up" do
      sanitizer = spy("sanitizer")
      allow(controller).to(receive(:devise_parameter_sanitizer).and_return(sanitizer))

      controller.send(:configure_permitted_parameters)

      expect(sanitizer).to(have_received(:permit).with(:sign_up).once)
    end
  end
end
