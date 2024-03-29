class StaticPagesController < ApplicationController
  def home
    @lists = current_user.lists.paginate(page: params[:page]) if current_user
  end

  def about
  end
end
