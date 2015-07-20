class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :update, :new, :edit]
  before_action :correct_user, only: [:destroy, :edit, :update] 

  def index
    @entries = Entry.all.paginate(page: params[:page])
  end
  def new
    @entry = current_user.entries.build
  end
  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      flash[:success] = "Entry created"
      redirect_to current_user
    else
      render 'new'  #goi lai view cua action tuong ung
    end
  end
  def edit
    @entry = current_user.entries.find_by(id: params[:id])

  end
  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(entry_params)
      flash[:success] = "Entry updated"
      redirect_to @entry
    else
      render 'edit'
    end
  end
  def show
    @entry = Entry.find_by(id: params[:id])
    @comments = @entry.comments.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def destroy
    @entry.destroy
    flash[:success] = "Entry deleted"
    redirect_to root_url
  end

  private
    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
    end
    def entry_params
      params.require(:entry).permit(:title, :body) # lay aram kieu bao mat for post. Binh thuong lay la params[:micropost][:content]
    end
end
