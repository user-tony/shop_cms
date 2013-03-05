#encoding: UTF-8
namespace :db do
  desc "升级模版信息,添加模版分类 版本升级到V0.1 对"
  task :up_temalate_to_v1 => :environment do
    begin
      Template.transaction do
        i = 1
        Template.ct_asc.each do |result|
          case result.name
          when "网站底部" then
            result.template_type = 801
            result.template_name = "footer"
          when "head头"  then
            result.template_type = 801
            result.template_name = "head"
          when "网站头部"  then
            result.template_type = 801
            result.template_name = "channel"
          when "新闻内容页"  then
            result.template_type = 501
            result.name = "新闻显示页"
            result.template_name = "news_show"
          when "新闻列表页"  then
            result.template_type = 301
            result.template_name = "news_list"
          when "新闻栏目页"  then
            result.template_type = 201
            result.template_name = "news_channel"
          when "首页"  then
            result.template_type = 101
            result.template_name = "index"
          when "订单内容页"  then
            result.template_type = 701
            result.template_name = "order_info"
          when "订单弹窗"  then
            result.template_type = 701
            result.template_name = "order_popwin"
          when "商城左侧栏"  then
            result.template_type = 701
            result.template_name = "shop_left"
          when "商城显示页"  then
            result.template_type = 701
            result.template_name = "shop_show"
          when "商城首页"  then
            result.template_type = 202
            result.template_name = "shop_index"
          when "服务验证表单"  then
            result.template_type = 601
            result.template_name = "service_form"
          when "用户单页"  then
            result.template_type = 601
            result.template_name = "user_single_page"
          when "新闻单页"  then
            result.template_type = 601
            result.name = "自定义单页"
            result.template_name = "news_single_page"
          when "留言板"  then
            result.template_type = 503
            result.template_name = "message_borad"
          end
          i += 2
          p "." * i
          p result
          result.save
        end
        p "----------------执行成功-------------------------"
      end
    end
  end
end








