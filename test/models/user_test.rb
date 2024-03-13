require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'testuser', email: 'testuser@test.com',
                     password: 'pass0123', password_confirmation: 'pass0123')
  end

  test 'testuserが存在するかのテスト' do
    assert @user.valid?
  end

  test 'name:が空でないか確認' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'name:が文字数制限(50文字)を超えてsaveされないか確認' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email:が空でないか確認' do
    @user.email = '     '
    assert_not @user.valid?
  end

  test 'email:が文字数制限(255文字)を超えてsaveされないか確認' do
    @user.email = "#{'a' * 244}+@example.com"
    assert_not @user.valid?
  end

  test 'email:に正しい値を入力した場合' do
    valid_addresses = %w[test100@example.com TestUSER@test.go.jp test_200-1@test.co.jp]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{@user.email}は有効(valid)であるべき"
    end
  end

  test 'email:に不正な値を入力した場合' do
    invalid_addresses = %w[test100@example,com TestUSER@test@go.jp test_200-1test.co.jp]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{@user.email}は無効(invalid)であるべき"
    end
  end

  test 'email:は一意の値でなければならない' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'パスワードが空白でないか' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'パスワードが短すぎないか(6文字以上か)' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'ダイジェストが存在しない場合の認証テスト' do
    assert_not @user.authenticated?(:remember, '')
  end
end
