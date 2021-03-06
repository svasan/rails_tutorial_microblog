class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        redirected_for_login? ? redirect_back : redirect_to(user)
      else
        flash[:warning] = "Account is not yet activated. Please check your email for the activation link."
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Incorrect email or password!"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
