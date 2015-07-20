class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :feed, :index, :update, :edit]
  before_action :correct_user, only: [:edit, :update]
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
  def index
    @users = User.all.paginate(page: params[:page], per_page: 5)
  end
  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private 
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_comfirmation)
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
end
