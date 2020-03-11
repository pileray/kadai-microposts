class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :update]
  
  def update
    path = Rails.application.routes.recognize_path(request.referrer)
    
    if path[:controller] == "toppages"
      path[:id] = current_user.id
      @user = current_user
    else  
      @user = User.find(path[:id])
    end
    
    if @micropost.update(micropost_params)
      if request.referer&.include?(likes_user_path(@user))
        respond_to do |format|
          format.js{ flash.now[:success] = 'メッセージを変更しました' }
          format.js{ render 'microposts/microposts', microposts: @user.added_to_favorites.page(params[:page]).per(25) }
          format.js{ render 'users/usertabs', user: @user }
        end
      elsif request.referer&.include?(user_path(@user))
        respond_to do |format|
          format.js{ flash.now[:success] = 'メッセージを変更しました' }
          format.js{ render 'microposts/microposts', microposts: @user.microposts.order(id: :desc).page(params[:page]).per(25) }
          format.js { render 'users/usertabs', user: @user }
        end
      else
        respond_to do |format|
          format.js{ flash.now[:success] = 'メッセージを変更しました'  }
          format.js{ render 'microposts/microposts', microposts: current_user.feed_microposts.order(id: :desc).page(params[:page]) }
        end
      end  
      render :update
    else
      flash.now[:danger] = 'メッセージの変更に失敗しました'
      render 'toppages/index'
    end
  end
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      respond_to do |format|
        format.js{ flash.now[:success] = 'メッセージを投稿しました' }
        format.js{ render 'microposts/microposts', microposts: current_user.feed_microposts.order(id: :desc).page(params[:page]) }
      end
      render :create
    else
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました'
      render 'toppages/index'
    end
  end

  def destroy
    @micropost.destroy
    path = Rails.application.routes.recognize_path(request.referrer)
    
    if path[:controller] == "toppages"
      path[:id] = current_user.id
      @user = current_user
    else  
      @user = User.find(path[:id])
    end
    
    if request.referer&.include?(likes_user_path(@user))
      respond_to do |format|
        format.js{ flash.now[:danger] = 'メッセージを削除しました。' }
        format.js{ render 'microposts/microposts', microposts: @user.added_to_favorites.page(params[:page]).per(25) }
        format.js{ render 'users/usertabs', user: @user }
      end
    elsif request.referer&.include?(user_path(@user))
      respond_to do |format|
        format.js{ flash.now[:danger] = 'メッセージを削除しました。' }
        format.js{ render 'microposts/microposts', microposts: @user.microposts.page(params[:page]).per(25) }
        format.js { render 'users/usertabs', user: @user }
      end
    else
      respond_to do |format|
        format.js{ flash.now[:danger] = 'メッセージを削除しました。' }
        format.js{ render 'microposts/microposts', microposts: current_user.feed_microposts.order(id: :desc).page(params[:page]) }
      end
    end  
    render :destroy
  end
  
  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
  
end
