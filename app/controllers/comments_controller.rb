class CommentsController < ApplicationController
  def index
  end
  
  def create
    #render text: params[:comment][:body]
    @comment = Comment.new(comment_params)
    @comment.save
    
    # render する前にインスタンス変数を作成
    @comments = Comment.all
    render 'welcome/index'
  end
  
  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
