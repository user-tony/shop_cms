#encoding: UTF-8
class QuestionsController < BaseController

  # 问答主页显示
  #
  # 作者：佟立家
  # 更新时间：2012-05-3
  def index
    channel = Channel.find_by_id(params[:channel_id])
    list = channel.answers.where("answer_status = 1").ct_desc.page(params[:page]).per(10)
    liquid_render channel.template_id_detail, :liquid => {
      "channel" => channel,
      "list" => list
    }
  end




  # 用户提问
  #
  # 作者：佟立家
  # 更新时间：2012-05-3
  def answer_create
    render :js => "alert('提交数据不能为空')" and return unless params[:answer].present?
    answer = Answer.new({:channel_id => params[:answer][:channel_id],
        :title => params[:answer][:title],
        :address => params[:answer][:address],
        :content => params[:answer][:content],
        :phone => params[:answer][:phone],
        :name => params[:answer][:name],
        :remote_ip => request.remote_ip
      })
    if answer.save
      render :js => 'alert("审核中,刷新页面可显示信息!");$("#answer_form")[0].reset();'
    else
      render :js => "alert('操作失败,请稍后重试')"
    end
  end


  #异步添加赞成数
  #
  # 作者：佟立家
  # 更新时间：2012-05-3
  def answer_top
    if params[:channel_id].present? && params[:answer_id].present?
      cookie_answer = cookies["answer_#{params[:channel_id]}"]
      number = 0      # 您今天已经支持过了
      number = Answer.add_approval(params[:answer_id]) if  !cookie_answer.present? || Time.now.to_date > cookie_answer.to_date
      cookies["answer_#{params[:channel_id]}"] = Time.now.to_date
    end
    render :json => { :number => number }    
  end
  
end
