class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".activation")
  end

  def password_reset
    @greeting = t ".greeting"

    mail to: t(".destination")
  end
end
