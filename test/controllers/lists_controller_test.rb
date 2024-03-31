require "test_helper"

class ListsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @list = lists(:orange)
  end

  test 'ログインしていない場合のList作成はログインページへリダイレクト' do
    assert_no_difference 'List.count' do
      post lists_path, params: { list: { content: 'Lorem ipsum' } }
    end
    assert_redirected_to login_url
  end

  test 'ログインしていない場合のList削除はログインページへリダイレクト' do
    assert_no_difference 'List.count' do
      delete list_path(@list)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test '別のユーザーのリストを削除しようとした場合、ルートへリダイレクト' do
    log_in_as(users(:michael))
    list = lists(:ants)
    assert_no_difference 'List.count' do
      delete list_path(list)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
