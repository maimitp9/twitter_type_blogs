class MicropostsController < ApplicationController
  before_action :signed_in_user
  #no need to define only: [] because we have only two action and we have to allow it to access after signin
  before_action :correct_user, only: :destroy
  # only admin user can delete feed means correct_user check admin or not

  def create
    @micropost = current_user.microposts.build(microposts_params)
    if @micropost.save
      flash[:success] = "Post created..."
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  private

  def microposts_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_path if @micropost.nil?
  end
end
