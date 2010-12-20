class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params[:comment])
    @comment.save
    @debt = @comment.debt
    contact = @debt.partner(current_user)
    CommentMailer.new_comment_email(contact, @comment).deliver if contact.is_a?(User)
    respond_to do |format|
      format.html { redirect_to(@debt) }
    end
  end
end
