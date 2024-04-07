class ItemsController < ApplicationController
  def create
    @list = List.find(params[:id])
    @item = @lists.new(item_params)
    if @item.save
      flash[:success] = 'itemを追加しました'
      redirect_to about_url
    end
  end

  def index
    @lists = List.paginate(page: params[:page])
  end

  private

  def item_params
    params.require(:item).permit(:content)
  end

end
