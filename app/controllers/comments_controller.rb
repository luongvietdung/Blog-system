class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy]

  def create
    @entry = Entry.find_by(id: params[:entry_id])
    @comment = @entry.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to @entry
    
    
  end

  def destroy
    @entry = @comment.entry
    if @comment.destroy
      flash[:success] = "Comment deleted"
    end
    redirect_to @entry
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end
