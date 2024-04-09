require "test_helper"

class ListsInterface < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end
end

class ListsInterfaceTest < ListsInterface
  test 'リストのページネーション確認' do
    get root_path
    #assert_select 'div.pagination' ページネーション追加後に再度テスト
  end

  test '不正な情報でリスト作成に失敗した際、エラーが表示される' do
    assert_no_difference 'List.count' do
      post lists_path, params: { list: { content: ' ' } }
    end
    assert_select 'div#error_explanation'
    #assert_select 'a[href=?]', '/page=2' ページネーション追加後に再度テスト
  end

  test '正しい情報でリスト作成した場合' do
    content = '正しい情報で作成'
    assert_difference 'List.count', 1 do
      post lists_path, params: { list: { content: content } }
    end
  end

  test '自身が所有するリストは削除することができる' do
    first_list = @user.lists.paginate(page: 1).first
    assert_difference 'List.count', -1 do
      delete list_path(first_list)
    end
  end
end
