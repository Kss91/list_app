class StaticPagesController < ApplicationController
  def home
    if logged_in?
    @list_new  = current_user.lists.build if logged_in?
    @list = List.find_by(user_id: current_user)
    @lists = current_user.lists.paginate(page: params[:page])
    @item  = @list.items.build
    end
  end

  def about
  end
end
