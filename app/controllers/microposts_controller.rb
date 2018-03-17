class MicropostsController < ApplicationController
  before_action :logged_in?, only: [:create, :destroy]

  def create
  end

  def destroy
  end
end
