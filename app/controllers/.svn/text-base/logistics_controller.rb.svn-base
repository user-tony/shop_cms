#encoding: UTF-8
class LogisticsController < BaseController
  
  # 请求所有物流信息
  # 
  # 作者：李季
  # 更新时间: 2012-05-03
  def logistics
    logistics = Logistic.get_logistics(params[:order_id])
    render :json => logistics.to_json
  end
  
end
