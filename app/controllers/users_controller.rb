class UsersController < ApplicationController
  
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likes, :destroy, :update]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザを登録しました'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました'
      render :new
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page]).per(25)
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page]).per(25)
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @microposts = @user.added_to_favorites.page(params[:page]).per(25)
    counts(@user)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = '退会しました。'
    redirect_to root_url
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィール画像を変更しました。"
      redirect_to @user
    else
      flash.now[:danger] = "プロフィール画像の変更に失敗しました。"
      render :show
    end
  end
      
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image, :remove_image)
  end
  
end
