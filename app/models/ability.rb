# -*- encoding : utf-8 -*-
class Ability

  include CanCan::Ability

  def initialize(user)

    # if user isn't in a group, he can manage everything (backward compatibility)
    if user.group.nil? or user.admin?
      can :manage, :all
    else
      user.group.permissions.eager_load(:resource).each do |permission|
        [:read, :create, :update, :destroy].each do |action|
          if permission.send("can_#{action}?")
           can action, permission.resource.name.constantize
          end
        end
      end
    end
  end
end
