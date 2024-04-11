# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(current_account)
    can(:read, Product)

    return if current_account.blank?

    if current_account.user?
      can(:read, Order, account_id: current_account.id)
      can(:create, Order, account_id: current_account.id)
      can(:update, Order, account_id: current_account.id)
      can(:create, Comment, account_id: current_account.id)
      cannot(:access_denied_user, :controller)
    elsif current_account.admin?
      can(:manage, :all)
    elsif current_account.manager?
      can(:manage, :all)
      cannot(:access_denied, :controller)
    end

    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
