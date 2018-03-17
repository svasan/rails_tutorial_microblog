class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  def hello
    render html: "hello world!"
  end

  private
  def logged_in?
    unless has_current_user?
      flash[:danger] = "Please log in"
      redirect_for_login
    end
  end

end
