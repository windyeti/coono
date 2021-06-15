# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user ||= User.new

    if user
      user.admin? ? admin : auth_user
    else
      guest
    end
  end

  def guest; end

  def auth_user
    guest
    can :manage, Distributor
    can :manage, Product
    can :manage, LitKom
    can :manage, Kovcheg
    can :manage, Nkamin
    can :manage, Tmf
    can :manage, Shulepov
  end

  def admin
    can :manage, :all
  end
end
