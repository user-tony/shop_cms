#encoding: UTF-8
class Admin::ShopOrdersController < Admin::BaseController
  #首页
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def index
    @order = Order.new
    @orders = Order.ct_desc
    @orders = @orders.where("recipient_name like ?", "%#{params[:order][:recipient_name]}%") if params[:order] && params[:order][:recipient_name].present?
    @orders = @orders.where("phone like ?", "%#{params[:order][:phone]}%") if params[:order] && params[:order][:phone].present?
    @orders = @orders.where("order_status = ?", params[:order][:order_status]) if params[:order] && params[:order][:order_status].present?
    @orders = @orders.where("payment_status = ?", params[:order][:payment_status]) if params[:order] && params[:order][:payment_status].present?
    @orders = @orders.where("scode like ?", "%#{params[:order][:scode]}%") if params[:order] && params[:order][:scode].present?
    @orders = @orders.where("TO_DAYS(created_at) >= TO_DAYS(?)", params[:start_time]) if params[:start_time].present?
    @orders = @orders.where("TO_DAYS(created_at) <= TO_DAYS(?)", params[:end_time]) if params[:end_time].present?
    @orders = @orders.page(params[:page]).per(20)
  end

  #编辑页
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def edit
    @order = Order.find(params[:id])
    if @order.logistic.blank?
      @logistic = Logistic.new
    else
      @logistic = @order.logistic
    end

  end

  # 更新订单信息
  # 当货运信息为空时，创建货运信息，当货运信息存在时，更新货运信息
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-04
  def update
    order = Order.find(params[:id])
    # 当货运公司，货运号都存在时
    if params[:logistic][:logistic_com].present? and params[:logistic][:logistic_num].present?
      # 如果货运信息不存在
      if order.logistic.blank?
        # 创建货运信息
        order.build_logistic(
          :logistic_com => params[:logistic][:logistic_com],
          :logistic_num => params[:logistic][:logistic_num])
      else
        # 更新货运信息
        order.logistic.update_attributes(
          :logistic_com => params[:logistic][:logistic_com],
          :logistic_num => params[:logistic][:logistic_num])
      end
    end

    if order.update_attributes(params[:order])
      flash[:success] = "编辑成功"
      redirect_to :action => "index"
    else
      flash[:error] = @shop_product.errors.messages.map{|m| m[1]}.join(",")
      redirect_to :back
    end
  end

  #导出订单
  #
  #作者：赵晓龙
  #更新时间：2012-04-18
  def export_xls
    row_name = "订单号 下单时间 总金额 订单状态 支付状态 收货人 电话 收货地址 备注 商品"

    @orders = Order.ct_desc
    @orders = @orders.where("id in (?)", params[:ids])
    #生成excel
    require "spreadsheet"
    xls_report = StringIO.new
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "o"
    blue = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 10
    sheet1.row(0).default_format = blue
    sheet1.row(0).concat row_name.split(" ")
    count_row = 1
    @orders.each do |obj|
      sheet1[count_row,0] = obj.scode
      sheet1[count_row,1] = obj.created_at.strftime("%Y-%m-%d %H:%M:%S") #日期
      sheet1[count_row,2] = obj.amount
      sheet1[count_row,3] = obj.order_status_cn
      sheet1[count_row,4] = obj.payment_status_cn
      sheet1[count_row,5] = obj.recipient_name
      sheet1[count_row,6] = obj.phone
      sheet1[count_row,7] = obj.address
      sheet1[count_row,8] = obj.remark
      #循环商品
      sheet1[count_row,9] = obj.order_products.inject(""){|result, o_product| result += "#{o_product.item.present? ? o_product.item.full_name : ""} "}
      count_row += 1
    end
    book.write xls_report
    send_data(xls_report.string,
      :type => "text/excel;charset=utf-8; header=present",
      :filename => "订单信息.xls")
  end
  
  # 删除订单 
  #
  # 作者：李季
  # 最后更新时间：2012-05-05
  def destroy
    order = Order.find(params[:id])
    if order.order_status > 0 || order.payment > 0
      flash[:notice] = "该订单不能删除"
    else
      order.destroy ? flash[:success] = "订单删除成功！" : flash[:error] = "订单删除失败！"
    end
    redirect_to :back
  end

  # 订单预览
  #
  # 作者：赵晓龙
  # 最后更新时间：2012-05-30
  def preview
    @order = Order.find(params[:id])
    render :layout => false
  end
end
