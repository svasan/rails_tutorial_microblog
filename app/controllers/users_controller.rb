class UsersController < ApplicationController

  before_action :require_login, :current_user?, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      if @user.save
        flash[:success] = "Profile updated!"
        redirect_to @user
      end
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_login
    unless logged_in?
      flash[:danger] = "Please log in"
      redirect_for_login
    end
  end

  def current_user?
    unless User.find(params[:id]) == current_user
      redirect_to root_url
    end
  end
end
