class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :feed]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Sign up success."
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @entries = @user.entries.paginate(page: params[:page], per_page: 5)
  end

  def feed
    @entries = current_user.feed.paginate(page: params[:page])
  end

  private 
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_comfirmation)
    end
end
