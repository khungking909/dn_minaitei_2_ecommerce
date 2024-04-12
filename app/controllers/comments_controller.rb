# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_account!
  load_resource only: :new
  authorize_resource only: %i(new create)
  def new; end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:success] = t("comments.create.success")
      redirect_to(product_path(@comment.product_id))
    else
      flash[:error] = t("comments.create.fail")
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.permit(:product_id, :content, :parent_id, :rating).merge(account_id: current_account.id)
  end
end
