#encoding: UTF-8
class Admin::AnswersController < Admin::BaseController

  def channel_index
    @channel =  Channel.find_by_id(params[:id])
    @answers = @channel.answers.ct_desc.page(params[:page]).per(20)
    render :layout => false if request.headers["X-Requested-With"]
  end

  def edit
    @answer = Answer.find(params[:id])
    render :layout => "iframe"
  end

  def create
    @answer = Answer.new  params[:answer]
    @answer.save ?  flash[:success] = "问题添加成功" : flash[:errors] = "添加失败"
    redirect_to admin_answers_path
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      render :js => "window.parent.$.jqmClose();window.parent.load_content();alert('保存成功');"
    else
      render :js => "alert('问题更新失败');"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.destroy
      render :js => "$('#answer_tr_#{@answer.id}').remove();"
    else
      render :js => "alert('删除失败');"
    end
  end

  def answer_admin
    @answer = Answer.find(params[:id])
    @admins = @answer.reply_answers.ct_desc
    @reply_answer = ReplyAnswer.new params[:reply_answer]
    render :layout => "iframe"
  end

  def reply_answer_create
    @reply_answer = ReplyAnswer.new params[:reply_answer]
    @reply_answer.management = 1    #管理员回复
     @answer = Answer.find_by_id(params[:reply_answer][:answer_id]) if @reply_answer.present?
    @answer.answer_status = 1 if @answer
    Answer.transaction do
      if @reply_answer.save && @answer.save
        flash[:success] = "添回管理员回复成功"
      else
        flash[:errors] = "添加管理员回复失败"
      end
    end
    
    redirect_to :back
  end

  def ajax_replay_answer_delete
    @reply_answer = ReplyAnswer.find params[:id]
    if @reply_answer.destroy
      render :js => "alert('该条评论删除成功');$('#content_#{@reply_answer.id}').remove();"
    else
      render :js => "alert('删除失败，请稍后重试！')"
    end
  end

  def ajax_replay_answer_auth
    @answer = Answer.find(params[:id])
    @answer.answer_status = @answer.answer_status.to_i == 1 ? 0 : 1    #管理员审核回复 answer_status
    if @answer.save
      render :js => "alert('操作成功');$('#auth_#{@answer.id}').text('#{@answer.answer_status.to_i == 1 ? '关闭' : '审核' }');;$('#answer_state_#{@answer.id}').text('#{@answer.answer_status.to_i == 1 ? '已通过' : '未审核' }')"
    else
      render :js => "alert('操作失败，请稍后重试！')"
    end
  end

  def batch_operation
    ids = params[:ids]
    if params[:audit].present?
      act = "audit"
    elsif params[:download].present?
      act = "download"
    end

    case act
      when "audit" then
        Answer.update_all("answer_status = 1", ["id in (?)",ids])
        render :js => "load_content();alert('操作成功');"
      when "download" then
        answers = Answer.order("id desc")
        answers = answers.where("title name ?", "%#{params[:name]}%") if params[:name].present?
        answers = answers.where("title like ?", "%#{params[:title]}%") if params[:title].present?
        answers = answers.where("TO_DAYS(created_at) >= TO_DAYS(?)", params[:start_time]) if params[:start_time].present?
        answers = answers.where("TO_DAYS(created_at) <= TO_DAYS(?)", params[:end_time]) if params[:end_time].present?

        row_name = "标题 姓名 电话 创建时间 状态 内容 回答"
        #生成excel
        require "spreadsheet"
        xls_report = StringIO.new
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet :name => "o"
        blue = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 10
        sheet1.row(0).default_format = blue
        sheet1.row(0).concat row_name.split(" ")
        count_row = 1
        answers.each do |answer|
          sheet1[count_row,0] = answer.title
          sheet1[count_row,1] = answer.name
          sheet1[count_row,2] = answer.phone
          sheet1[count_row,3] = answer.created_at.strftime("%Y-%m-%d %H:%M:%S") #日期
          sheet1[count_row,4] = answer.answer_status.to_i == 1 ? "已通过" : "未审核"
          sheet1[count_row,5] = answer.content
          column_index = 6
          answer.reply_answers.each_with_index do |reply, index|
            sheet1[count_row,column_index + index] = reply.content
          end
          count_row += 1
        end
        book.write xls_report
        send_data(xls_report.string,
          :type => "text/excel;charset=utf-8; header=present",
          :filename => "问答信息.xls") and return
    end
  end
end
