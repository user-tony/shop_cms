#encoding: UTF-8
class Admin::CommentsController < Admin::BaseController
  #评论管理首页
  #
  #作者：赵晓龙
  #更新时间：2012-06-29
  def index
    @comment = Comment.new

    @comments = Comment.order("id asc")
    @comments = @comments.page(params[:page]).per(20)
  end

  #编辑
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def edit
    @comment = Comment.find_by_id(params[:id])
    render :new
  end

  #更新
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def update
    comment = Comment.find_by_id(params[:id])
    comment.update_attributes(params[:comment])
    flash[:success] = "修改成功！"
    redirect_to admin_comments_path
  end

  #删除
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:success] = "删除成功！"
    redirect_to admin_comments_path
  end

  #批量操作
  #
  #作者：赵晓龙
  #更新时间：2012-06-30
  def batch_act
    if params[:act_passed].present?
      comments = Comment.where("id in (?)", params[:ids])
      comments.update_all(:status => Comment::STATUS_PASSED)
    elsif params[:act_not_passed].present?
      comments = Comment.where("id in (?)", params[:ids])
      comments.update_all(:status => Comment::STATUS_NOT_PASSED)
    elsif params[:act_batch_delete].present?
      comments = Comment.where("id in (?)", params[:ids])
      comments.destroy_all
    end
    redirect_to :back
  end
end