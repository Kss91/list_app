require 'test_helper'

class ListTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @list = @user.lists.new(content: 'カテゴリA', user_id: @user.id)
  end

  test '有効か確認' do
    assert @list.valid?
  end

  test 'user_idが存在するか確認' do
    @list.user_id = nil
    assert_not @list.valid?
  end

  test 'contentが存在するか確認' do
    @list.content = ' '
    assert_not @list.valid?
  end

  test 'contentの文字数制限20を超えていないか' do
    @list.content = 'a' * 21
    assert_not @list.valid?
  end

  test '最新の情報が最初に来るような順番になっているか' do
    assert_equal lists(:most_recent), List.first
  end
end
