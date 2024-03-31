class StaticPagesController < ApplicationController
  def home
    if logged_in?
    @list  = current_user.lists.build if logged_in?
    @lists = current_user.lists.paginate(page: params[:page])
    end
  end

  def about
  end
end
