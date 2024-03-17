require "test_helper"

class UserMailerTest < ActionMailer::TestCase

  test 'アカウント有効化' do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'ListApp アカウント有効化をしてください', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['user@realdomain.com'], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  test 'パスワードリセット' do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal 'ListApp パスワード再設定', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['user@realdomain.com'], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end
