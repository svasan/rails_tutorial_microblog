class StaticPagesController < ApplicationController
  def home
    if has_current_user?
      @micropost = current_user.microposts.build
      @feed = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
