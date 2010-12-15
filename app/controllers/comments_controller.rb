class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params[:comment])
    @comment.save
    @debt = @comment.debt
    respond_to do |format|
      format.html { redirect_to(@debt) }
    end
  end
end
