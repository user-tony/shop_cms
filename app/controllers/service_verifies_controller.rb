#encoding: UTF-8
class ServiceVerifiesController < BaseController
  #产品验证
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def verify
    #获得栏目模型信息
    service  = Template.get_template_name("service_form").first
    #寻找模版
    render_404 and return unless service.present?
    #输出页面
    liquid_render service.id , :liquid => {
      "message" => flash[:notice]
    }
  end

  #用户验证提交
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def verify_save
    #检测输入位数
    if params[:number].to_s.strip.size != 16
      flash[:notice] = "序列号必须是16位"
      redirect_to :back and return
    end

    #判断是否有效
    if verify = ServiceVerify.find(:first, :conditions => ["serial_number = ?", params[:number]])
      if verify.status == ServiceVerify::STATUS_READY
        #更新序列号状态
        verify.update_attributes({:verify_num => verify.verify_num + 1, :verify_at => Time.now})
        flash[:notice] = "您验证的产品“#{verify.service_category.name}”，是正品"
      else verify.status == ServiceVerify::STATUS_LOCK
        flash[:notice] = "序列号已被锁定"
      end
    else
      flash[:notice]= "序列号不存在，请重新输入"
    end
    redirect_to :back and return
  end
end
