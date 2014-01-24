class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new # guest user (not logged in)

        unless user.new_record?
            if user.kind_of? Admin
                # admins can do this stuff
                can :show, User
                can [:new,:create, :destroy], Bid, order: {state: 'submitted'} if user.payable?
                can :show, Admin
                can :show, Review
                can :pool, Order
                can :mybids, Order
                can :manage, Product
                can [:new, :create, :show, :edit, :update, :destroy], Storefront
                can [:index, :new, :create, :show, :edit, :update], Order
                can :estimate, Order, state: 'submitted'
                can :manage, [Message, ActiveChat], admin_id: user.id
                can :pay, Order, state: 'estimated'
                can :complete, Order, state: 'production'
                can :ship, Order, state: 'completed'
                can :archive, Order, state: 'shipped'
                cannot :destroy, Admin, id: user.id
            else
                # clients can do this stuff
                can [:show, :update], User, id: user.id  # user can always see their own account
                can :manage, [Message, ActiveChat], user_id: user.id
                can [:show, :edit, :update], Storefront
                can :manage, Review
                can :show, Admin
                can :show, Product
                can [:select, :update], Bid
                #can :manage, ProjectFile, :project => { :user_id => user.id }
                can [:index, :new, :create, :show, :edit, :update], Order
                can :estimate, Order
                can :destroy, Order, state: ['submitted', 'estimated']
                can :pay, Order, state: 'estimated'
                # TODO
                # cannot [:edit, :update, :destroy], Order, state: (Order.available_states - ['submitted'])
            end
        end

        cannot [:edit, :update], Order, state: 'archived'
        # cannot :destroy, ProjectFile do |file|
        #     file.orders.any? or file.shipped_orders.any?
        # end
    end
end
#, project: {user_id: user.id }