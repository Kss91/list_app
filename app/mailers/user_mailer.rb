class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'ListApp アカウント有効化をしてください'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'ListApp パスワード再設定'
  end
end
