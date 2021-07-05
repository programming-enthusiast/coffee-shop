class OrderMailer < ApplicationMailer
  default from: "noreply@coffeeshop.com"
  default body: "Thank you"

  def order_complete(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Order Complete",
      body: "Order Complete"
    )
  end
end
