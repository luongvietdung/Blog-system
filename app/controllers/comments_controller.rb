class CommentsController < ApplicationController
  def create
    @entry = Entry.find_by(id: params[:entry_id])
    @comment = @entry.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to @entry
  end

  def destroy
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
