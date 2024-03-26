# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'ログインしていない場合、editページに飛ぶとリダイレクトされる' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path, status: :see_other_
  end

  test 'ログインしていない場合、updateを実行してもリダイレクトされる' do
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_path, status: :see_other_
  end

  test '別のユーザーがeditページに飛ぶとリダイレクトされる' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url, status: :see_other
  end

  test '別のユーザーからupdateを実行してもリダイレクトされる' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url, status: :see_other
  end

  test 'ログインしていない場合、indexにアクセスするとリダイレクトされる' do
    get users_path
    assert_redirected_to login_url
  end

  test 'ログインしていない場合、ユーザー削除しようとしてもリダイレクトされる' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test 'adminではないユーザーでログインしている場合、ユーザー削除しようとしてもリダイレクトされる' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

  test 'ログインしていない状態でフォローユーザー一覧にアクセスしてもリダイレクトされる' do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test 'ログインしていない状態でフォロワーユーザー一覧にアクセスしてもリダイレクトされる' do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
