require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                      followed_id: users(:archer).id)
  end

  test '有効化どうかテスト' do
    assert @relationship.valid?
  end

  test 'follower_idが必要である事のテスト' do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test 'followed_idが必要である事のテスト' do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
