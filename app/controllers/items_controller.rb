class ItemsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :index]
  before_action :correct_user,   only: :destroy

  def create
    @item = Item.new(content: item_params[:content], list_id: item_params[:list_id])
    if @item.save
      flash[:success] = 'itemを追加しました'
    else
      flash[:danger] = 'item作成に失敗しました'
    end
    redirect_to root_url
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:success] = 'アイテムを削除しました'
    redirect_to root_url
  end

  def index
    @list = List.find(params[:list_id])
  end

  private

  def item_params
    params.require(:item).permit(:content, :list_id)
  end

  def correct_user
    @list = current_user.lists.find_by(id: params[:list_id])
    @item = @list.items.find_by(id: params[:id])
    redirect_to root_url, status: :see_other if @item.nil?
  end
end
