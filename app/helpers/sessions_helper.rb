module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
    remember user if params[:session] && params[:session][:remember_me] == '1'
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    if logged_in?
      forget current_user
      session.delete(:user_id)
      @current_user = nil
    end
  end

  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def current_user?(user)
    current_user == user
  end

  def redirect_for_login
    session[:original_url] = request.original_url if request.get?
    redirect_to login_url
  end

  def redirected_for_login?
    session.has_key?(:original_url)
  end

  def redirect_back
    to = session[:original_url] || root_url
    session.delete(:original_url)
    redirect_to to
  end
end
