class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    
    @micropost = Micropost.find(params[:micropost_id])
    current_user.add_to_favorites(@micropost)
    if request.referer&.include?(user_path(current_user)) || request.referer&.include?(likes_user_path(current_user))
      respond_to do |format|
        format.js { flash.now[:success] = 'Micropostをお気に入りに追加しました。' }
        format.js { render 'users/usertabs', user: current_user }
        format.js { render 'microposts/microposts', microposts: current_user.added_to_favorites.page(params[:page]).per(25) }
      end
    else
      respond_to do |format|
        format.js { flash.now[:success] = 'Micropostをお気に入りに追加しました。' }
      end  
    end 
    render :create
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.remove_from_favorites(@micropost)
    if request.referer&.include?(user_path(current_user)) || request.referer&.include?(likes_user_path(current_user))
      respond_to do |format|
        format.js { flash.now[:danger] = 'Micropostをお気に入りから削除しました' }
        format.js { render 'users/usertabs', user: current_user }
        format.js { render 'microposts/microposts', microposts: current_user.added_to_favorites.page(params[:page]).per(25) }
      end
    else
      respond_to do |format|
        format.js { flash.now[:danger] = 'Micropostをお気に入りから削除しました' }
      end  
    end
    render :destroy
  end
end
