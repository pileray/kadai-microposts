class RelationshipsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @user = User.find(params[:follow_id])
    current_user.follow(@user)
    respond_to do |format|
      format.js { flash.now[:success] = 'ユーザをフォローしました' }
      format.js { render 'users/usertabs', user: @user }
    end
    render :create
  end

  def destroy
    @user = User.find(params[:follow_id])
    current_user.unfollow(@user)
    respond_to do |format|
      format.js { flash.now[:danger] = 'ユーザのフォローを解除しました' }
    end
    render :destroy
  end
end
