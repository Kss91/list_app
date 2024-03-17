require "test_helper"

class PasswordResets < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class ForgotPasswordFormTest < PasswordResets

  test 'パスワードリセットpath' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
  end

  test '不正なemailでのreset path' do
    post password_resets_path, params: { password_reset: { email: ' ' } }
    assert_response :unprocessable_entity
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end
end

class PasswordResetForm < PasswordResets
  def setup
    super
    @user = users(:michael)
    post password_resets_path, params: { password_reset: { email: @user.email } }
    @reset_user = assigns(:user)
  end
end

class PasswordFormTest < PasswordResetForm
  test '正しいemailでのreset path' do
    assert_not_equal @user.reset_digest, @reset_user.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test '不正なemailでのパスワードリセット' do
    get edit_password_reset_path(@reset_user.reset_token, email: '')
    assert_redirected_to root_url
  end

  test '有効化されていないユーザーでのパスワードリセット' do
    @reset_user.toggle!(:activated)
    get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
    assert_redirected_to root_url
  end

  test '正しいemailと不正なトークンでのパスワードリセット' do
    get edit_password_reset_path('wrong token', email: @reset_user.email)
    assert_redirected_to root_url
  end

  test '正しいemailと正しいトークンでのパスワードリセット' do
    get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', @reset_user.email
  end
end

class PasswordUpdateTest < PasswordResetForm
  test '不正なパスワード/パスワード確認でのパスワード修正' do
    patch password_reset_path(@reset_user.reset_token),
          params: { email: @reset_user.email,
                    user: { password: 'foobaz',
                            password_confirmation: 'barquux' } }
    assert_select 'div#error_explanation'
  end

  test '空のパスワードでのパスワード修正' do
    patch password_reset_path(@reset_user.reset_token),
          params: { email: @reset_user.email,
                    user: { password: ' ',
                            password_confirmation: ' ' } }
    assert_select 'div#error_explanation'
  end

  test '正しい内容でのパスワード修正' do
    patch password_reset_path(@reset_user.reset_token),
          params: { email: @reset_user.email,
                    user: { password: 'foobar',
                            password_confirmation: 'foobar' } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to @reset_user
  end
end
