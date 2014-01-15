class OrderNotifications < ActionMailer::Base
  default from: "no-reply@cadsurf.com"

  # subject lines are set in the i18n file, en.yml

  def estimate(order)
    @order = order

    mail to: order.user.email
  end

  def thank_you(order)
    @order = order

    mail to: order.user.email
  end

  def paid(order)
    @order = order

    mail to: order.admin.email
  end

  def complete(order)
    @order = order

    mail to: order.user.email
  end

  def shipped(order)
    @order = order

    mail to: order.user.email
  end
end
