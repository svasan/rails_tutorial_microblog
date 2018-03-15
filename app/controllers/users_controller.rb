class UsersController < ApplicationController

  before_action :require_login, only: [:index, :edit, :update, :destroy]
  before_action :current_user?, only: [:edit, :update]
  before_action :admin?, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "Please check your email to activate your account!"
      redirect_to root_url
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
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

  def admin?
    redirect_to root_url unless current_user.admin?
  end
end
