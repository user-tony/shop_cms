#encoding: UTF-8
class Logistic < ActiveRecord::Base
  
  belongs_to :order
  
  LOGISTIC_COM = [["申通", 'shentong'],["海航天天", 'tiantian'],["中通快递", 'zhongtong'], ["圆通速递", 'yuantong'], ['ems快递', 'ems']]

  mango_liquid
  
  class << self
    
    
    # 获取物流信息
    #
    # 作者: 李季
    # 最后更新时间: 2012-05-04
    #
    # ==== 参数
    # * <tt>com</tt> - 货运公司代码
    # * <tt>nu</tt> - 货运号
    #
    # ==== 模板示例
    #   get_logistics("yuantong", "2251646825")
    #
    # ==== 返回
    #   全部货运信息
    
    def request_logistics(com, nu)
      begin
        req_headers = {
          'Content-Type' => 'text/xml; charset=utf-8',
          'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT)'
        }
        Net::HTTP.start('api.kuaidi100.com') do |http|
          req = Net::HTTP::Get.new("/query?type=#{com}&postid=#{nu}",req_headers)
          response = http.request(req)
          result = response.body
          result = ActiveSupport::JSON.decode(result)
          result["data"]
        end
      rescue
        nil
      end
    end
    
    
    # 获取最新物流信息
    #
    # 作者: 李季
    # 最后更新时间: 2012-05-04
    #
    # ==== 参数
    # * <tt>com</tt> - 货运公司代码
    # * <tt>nu</tt> - 货运号
    #
    # ==== 模板示例
    #   request_newest_logistic("yuantong", "2251646825")
    #
    # ==== 返回
    #   Json - 最新货运信息
    def request_newest_logistic(com,nu)
      begin
        req_headers = {
          'Content-Type' => 'text/xml; charset=utf-8',
          'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT)'
        }
        Net::HTTP.start('api.kuaidi100.com') do |http|
          req = Net::HTTP::Get.new("/apione?com=#{com}&nu=#{nu}",req_headers)
          response = http.request(req)
          result = response.body
          result = ActiveSupport::JSON.decode(result)
          result["data"]        
        end
      rescue
        nil
      end
    end
    
    # 根据订单号获取全部物流信息
    #
    # 作者：李季
    # 最后更新时间：2012-05-09
    # * <tt>order_id</tt> - 订单ID
    #
    # ==== 模板示例
    #   get_logistics(155)
    #
    # ==== 返回
    #   Hash - 全部货运信息
    def get_logistics(order_id)
      order = Order.find_by_id(order_id)
      if order.logistic.present?
        if !order.logistic.logistic_com.in? ["ems","shentong"]
          com = order.logistic.logistic_com
          nu = order.logistic.logistic_num
          result = self.request_logistics(com, nu)
        else
          if order.logistic.logistic_com == "ems"
            return {"message" => "您的物流号为'#{order.logistic.logistic_num}',请前往'EMS'查询"}
          else
            return {"message" => "您的物流号为'#{order.logistic.logistic_num}',请前往'申通'查询"}
          end
        end
      else
        return {"message" => "未发货！"}
      end
      if result.present?
        result.delete(result.second)
        result
      else
        {"message" => "对不起，物流信息不存在！"}
      end
    end
    
    
    # 根据订单号获取最新物流信息
    #
    # 作者：李季
    # 最后更新时间：2012-05-09
    # * <tt>order_id</tt> - 订单ID
    #
    # ==== 模板示例
    #   get_logistics(155)
    #
    # ==== 返回
    #   Hash - 全部货运信息
    def get_logistic(order_id)
      order = Order.find_by_id(order_id)
      
      if order.logistic.present?
        if !order.logistic.logistic_com.in? ["ems","shentong"]
          com = order.logistic.logistic_com
          nu = order.logistic.logistic_num
          result = self.request_newest_logistic(com, nu)
        else
          if order.logistic.logistic_com == "ems"
            return {"context" => "您的物流号为'#{order.logistic.logistic_num}',请前往'EMS'查询"}
          else
            return {"context" => "您的物流号为'#{order.logistic.logistic_num}',请前往'申通'查询"}
          end
        end
      else
        return {"context" => "未发货！"}
      end
      if result.present?
        result.first
      else
        {"context" => "对不起，物流信息不存在！"}
      end
    end
  end
  
end
