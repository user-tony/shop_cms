#encoding: UTF-8
class Admin::BaseController < ApplicationController

  layout "admin" 
  before_filter :authorities, :except => [:login, :check_login]


  
  def authorities
    if session[:manager_id]
      @manager_curr = Manager.find_by_id(session[:manager_id])
    else
      redirect_to login_admin_managers_path, :notice => "请登录"
    end
#  rescue
#    session[:manager_id] = nil
#    redirect_to login_admin_manager_path, :notice => "数据异常，请重新登录"
  end

  # ajax提示
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-13
  # ==== 参数
  # * <tt>type</tt> - 提示类型，可用参数（:success, :error, :notice）
  # * <tt>msg</tt> - 提示信息
  #
  # ==== 模板示例
  #   prompt(:success, "操作成功")
  #
  # ==== 返回
  #   js方法
  #
  def prompt(type, msg)
    "prompt('#{type.to_s}', '#{msg}');"
  end
  
end
