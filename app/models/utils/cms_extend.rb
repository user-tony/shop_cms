#encoding: UTF-8
class Utils::CmsExtend
  
 

    # 根据时间对数字进行累加
    #
    # 作者: 李季
    # 最后更新时间: 2012-05-09
    #
    # ==== 参数
    # * <tt>init_time</tt> - 起始时间
    # * <tt>time</tt> - 间隔时间
    # * <tt>step</tt> - 步长
    # * <tt>init_num</tt> - 初值
    #
    # ==== 模板示例
    #   Utils::CmsExtend.time_count("2012-05-09 12:12:12", 30, 5, 10000)
    #
    # ==== 返回
    #   整数 12950
    #
    def self.time_count(init_time, time, step, init_num)
      (Time.now.to_i - init_time.to_datetime.to_i)/time * step + init_num
    end
 


    # 添模版方法
    #
    # 作者: 佟立家
    # 最后更新时间: 2012-7-13 9:51:27
    #
    # ==== 参数
    # * <tt>file_name</tt> - 模版文件名
    # * <tt>name</tt> - 模版中文名
    # * <tt>template_name</tt> - 模版英文名   
    # * <tt>model_id</tt> -  模型ID
    # * <tt>cate_id</tt> - 模版分类ID
    # * <tt>type_id</tt> - 模版类型ID
    #
    # ==== 模板示例
    #   Utils::CmsExtend.template_crete("cart","购物车模版","cart",2,4,3)
    #
    # ==== 返回
    #   整数 12950
    #
     def self.template_crete(file_name,name,template_name,model_id,cate_id,type_id)
        temp_path = "#{Rails.root}/lib/cms/init_templates/#{file_name}.html"
        if File.exists?(temp_path)
            File.open(temp_path, "r") do |f|
                           Template.create(:name => name, 
                             :template_name => template_name,
                             :description => "系统默认模板",
                             :content => f.read, 
                             :info_model_id => model_id, 
                             :template_category_id =>  cate_id,
                             :template_type => type_id,
                             :template_status => true
                             )
            end
        else
          puts "《#{name}》不存在.."
        end
     end



end