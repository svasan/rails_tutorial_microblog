class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]
  before_action :valid_user?, only: [:edit, :update]
  before_action :valid_token?, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_token
      @user.send_password_reset_email
      flash[:success] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user?
    if not @user
      flash[:danger] = "Invalid email"
      redirect_to root_url
    elsif not @user.activated?
      flash[:danger] = "User has not been activated. Please check your email for the activation link."
      redirect_to root_url
    end
  end

  def valid_token?
    if not @user.authenticated?(:reset, params[:id])
      flash[:danger] = "Invalid password reset link"
      redirect_to new_password_reset_path
    elsif not @user.reset_valid?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_path
    end
  end

  def user_params
    params.require(:reset).permit(:password, :password_confirmation)
  end
end
