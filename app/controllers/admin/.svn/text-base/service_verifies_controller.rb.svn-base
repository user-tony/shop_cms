#encoding: UTF-8
class Admin::ServiceVerifiesController < Admin::BaseController
  #序列号管理首页
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def index
    @service_verify = ServiceVerify.new
    
    @service_verifies = ServiceVerify.order("id asc")
    @service_verifies = @service_verifies.by_category_id(params[:service_verify][:service_category_id].to_i) if params[:service_verify] && params[:service_verify][:service_category_id].to_i > 0
    @service_verifies = @service_verifies.like_serial_number(params[:service_verify][:serial_number]) if params[:service_verify] && params[:service_verify][:serial_number].present?
    @service_verifies = @service_verifies.page(params[:page]).per(20)
  end

  # 批量导入
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-23
  def import;end

  # 批量导入保存
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-23
  def import_save
    unless params[:file]
      flash[:notice] = "请选择文件"
    end
    category_id = params[:category_id].to_i
    begin
      upload_count = 0
      file = params[:file]
      require "spreadsheet"
      xls_report = Spreadsheet.open(file.path)
      xls_report.worksheet(0).each do |row|
        upload_count += 1
        if ServiceVerify.where("serial_number = ?", row[1]).size == 0
          pwd = Util::Secret.enpwd(row[1].strip) if row[1].present?
          ServiceVerify.create(:service_category_id => category_id, :serial_number =>row[0].to_s.strip, :password => pwd, :status => ServiceVerify::STATUS_READY)
        end
      end
      flash[:success] = "上传成功#{upload_count}条序列号。"
    rescue
      flash[:notice] = "文件格式不正确！"
    end
    redirect_to :action => :import
  end

  # 操作序列号
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-23
  def operation
    act = params[:act].to_s
    service_verify = ServiceVerify.find(params[:id])

    case act
    when "lock"
      service_verify.lock
    when "unlock"
      service_verify.unlock
    end

    redirect_to :back
  end

  # 批量操作页面
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-23
  def export;end
  # 批量操作
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-23
  def export_save
    select_type = params[:select_type]
    status = params[:status].to_i
    category_id = params[:category_id].to_i
    start_id = params[:start_id].to_i
    start_id2 = params[:start_id2].to_i
    end_id = params[:end_id].to_i
    end_count = params[:end_count].to_i
    act =  params[:act]
    #判断筛选模式

    result = ServiceVerify.where("service_category_id = ?", category_id)
    if select_type == "id"
      if start_id > 0 && end_id > start_id
        result = result.where("id >= ? AND id <= ?", start_id,end_id)
      else
        flash[:notice] = "开始或结束id必须大于0"
        redirect_to :back and return
      end
    else
      if start_id2 > 0 && end_count > 0
        result = result.where("id >= ?", start_id2).limit(end_count)
      else
        flash[:notice] = "开始id和数量必须大于0"
        redirect_to :back and return
      end
    end
    if result
      ServiceVerify.transaction do
        #判断动作
        case act
        when "set_status" then
          #修改序列号状态
          ServiceVerify.update_all({:status => status}, ["id IN (?)",result.map{|obj|obj.id}])
        when "delete" then
          #删除序列号
          ServiceVerify.delete(result.map{|obj|obj.id})
        end
      end
      flash[:notice] = "已处理#{result.size}条"
    else
        flash[:notice] = "没有结果"
    end
    redirect_to :back
  end
end
