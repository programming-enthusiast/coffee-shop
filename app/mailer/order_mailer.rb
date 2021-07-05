class OrderMailer < ApplicationMailer
  default from: "noreply@coffeeshop.com"
  default body: "Thank you"

  def order_complete(user, content)
    @user = user

    mail(
      to: @user.email,
      subject: "Order Complete",
      body: content
    )
  end
end
