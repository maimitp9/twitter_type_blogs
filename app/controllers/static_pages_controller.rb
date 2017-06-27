class StaticPagesController < ApplicationController
  def home
    # print feed of pericular user on the home page
    # feed is method declared in user model
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def contact
  end

  def about
  end
end
