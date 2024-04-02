class ListsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update]
  before_action :correct_user,   only: [:destroy, :edit, :update]

  def create
    @list = current_user.lists.build(list_params)
    if @list.save
      flash[:success] = 'リストを作成しました'
      redirect_to root_url
    else
      @lists = current_user.lists.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
    flash[:success] = 'リストを削除しました'
    redirect_to root_url
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      flash[:success] = 'リスト名を修正しました'
      redirect_to root_url
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def list_params
    params.require(:list).permit(:content)
  end

  def correct_user
    @list = current_user.lists.find_by(id: params[:id])
    redirect_to root_url, status: :see_other if @list.nil?
  end
end
