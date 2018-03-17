class MicropostsController < ApplicationController
  before_action :logged_in?, only: [:create, :destroy]
  before_action :posted_by?, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micro_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # The micropost submit failed.
      # Set @feed here since we directly render the home page.
      # The user is logged_in? here, so @feed should be non-nil for
      # the home page, to be rendered.
      # Set it to the proper value so the actual feed is rendered even
      # in the error case.
      @feed = current_user.microposts.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    msg = "Micropost '#{@micropost.content.truncate(15)}...' deleted."
    @micropost.destroy
    flash[:success] = msg
    redirect_to request.referrer || root_url
  end

  private
  def micro_params
    params.require(:micropost).permit(:content, :picture)
  end

  def posted_by?
    @micropost = Micropost.find(params[:id])
    redirect_to root_url if current_user != @micropost.user
  end
end
