#encoding: UTF-8
class AddTemplateCategoryIdToTemplate < ActiveRecord::Migration

  def up
    add_column :templates, :template_category_id,  :integer                  #添加模版分类ID

    Template.transaction do

      #模板初始数据
      templates = [
        ["search_category", "搜索分类页", 4],
        ["payment", "支付页", 3],
        ["order_list", "我的订单列表", 3],
        ["order_show", "订单详细页", 3],
        ["search", "搜索页", 3],
        ["order_address", "确认订单页", 3],
        ["cart", "购物车页面", 3],
        ["message_borad", "留言板", 6],
        ["news_single_page", "自定义页", 1],
        ["user_single_page", "用户单页", 4],
        ["user_pop_sign_single_page", "用户弹窗单页", 4],
        ["service_form", "服务验证表单", 2],
        ["shop_index", "商城首页", 2],
        ["shop_show", "商城显示页", 2],
        ["shop_left", "商城左侧栏", 2],
        ["order_popwin", "订单弹窗", 2],
        ["order_info", "订单内容页", 3],
        ["index", "首页", 1],
        ["news_channel", "新闻栏目页", 1],
        ["news_list", "新闻列表页", 1],
        ["news_show", "新闻显示页", 1],
        ["channel", "网站头部", 1],
        ["head", "head头", 1],
        ["footer", "网站底部", 1]
      ]

      templates.reverse_each do |file, name, info_model_id,category_id,type|
        temp_path = "#{Rails.root}/lib/cms/init_templates/#{file}.html"
        p temp_path
        if File.exists?(temp_path)
          File.open(temp_path, "r") do |f|
            puts ".....导入《#{name}》成功..." if Template.create(:name => name, :template_name => file, :description => "系统默认模板", :content => f.read, :info_model_id => info_model_id, :template_status => true)
            end
        else
          puts "《#{name}》不存在.."
        end
      end
   
      #初始化模版分类ID
      partil_id = 15        #  TemplateCategory.get_id("片段")
      new_show_id = 7       #  TemplateCategory.get_id("新闻显示页")
      new_list_id = 4       #  TemplateCategory.get_id("新闻列表页")
      new_channel_id = 2    #  TemplateCategory.get_id("新闻栏目页")
      index_id  = 1         #  TemplateCategory.get_id("首页")
      shop_show_id = 8      #  TemplateCategory.get_id("商城显示页")
      shop_index_id = 3     #  TemplateCategory.get_id("商城首页")
      single_page_id = 13   #  TemplateCategory.get_id("单页")
      order_id = 12         #  TemplateCategory.get_id("订单")
      content_id = 9        #  TemplateCategory.get_id("留言显示页")

      #修改以前模版信息
      Template.ct_asc.each do |result|
        case result.name
        when "网站底部" then
          result.template_category_id = partil_id
          result.template_name = "footer"
          result.template_type = Template::TEMPLATE_TYPE[:partil_type]
        when "head头"  then
          result.template_category_id = partil_id
          result.template_name = "head"
          result.template_type = Template::TEMPLATE_TYPE[:partil_type]
        when "网站头部"  then
          result.template_category_id = partil_id
          result.template_name = "channel"
          result.template_type = Template::TEMPLATE_TYPE[:partil_type]
        when "新闻显示页"  then
          result.template_category_id = new_show_id
          result.template_name = "news_show"
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #显示页面
        when "新闻内容页"  then
          result.template_category_id = new_show_id
          result.name = "新闻显示页"
          result.template_name = "news_show"
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #显示页面
        when "新闻列表页"  then
          result.template_category_id = new_list_id
          result.template_name = "news_list"
          result.template_type = Template::TEMPLATE_TYPE[:list_type]    #列表页面
        when "新闻栏目页"  then
          result.template_category_id = new_channel_id
          result.template_name = "news_channel"
          result.template_type = Template::TEMPLATE_TYPE[:channel_type]    #列表页面
        when "首页"  then
          result.template_category_id = index_id
          result.template_name = "index"
          result.template_type = Template::TEMPLATE_TYPE[:index_type]    #首页
        when "订单内容页"  then
          result.template_category_id = order_id
          result.template_name = "order_info"
          result.template_type = Template::TEMPLATE_TYPE[:single_type]    #单页
        when "订单弹窗"  then
          result.template_category_id = order_id
          result.template_name = "order_popwin"
          result.template_type = Template::TEMPLATE_TYPE[:partil_type]    #片段
        when "商城左侧栏"  then
          result.template_category_id = partil_id
          result.template_name = "shop_left"
          result.template_type = Template::TEMPLATE_TYPE[:partil_type]
        when "商城显示页"  then
          result.template_category_id = shop_show_id
          result.template_name = "shop_show"
          result.template_type = Template::TEMPLATE_TYPE[:content_type]
        when "商城首页"  then
          result.template_category_id = shop_index_id
          result.template_name = "shop_index"
          result.template_type = Template::TEMPLATE_TYPE[:channel_type]
        when "服务验证表单"  then
          result.template_category_id = single_page_id
          result.template_name = "service_form"
          result.template_type = Template::TEMPLATE_TYPE[:single_type]    #单页
        when "用户单页"  then
          result.template_category_id = single_page_id
          result.template_name = "user_single_page"
          result.template_type = Template::TEMPLATE_TYPE[:single_type]    #单页
        when "自定义单页"  then
          result.template_category_id = single_page_id
          result.template_name = "news_single_page"
          result.template_type = Template::TEMPLATE_TYPE[:single_type]    #单页
        when "新闻单页"  then
          result.template_category_id = single_page_id
          result.name = "自定义单页"
          result.template_name = "news_single_page"
          result.template_type = Template::TEMPLATE_TYPE[:single_type]    #单页
        when "自定义页"  then
          result.template_category_id = single_page_id
          result.name = "自定义单页"
          result.template_name = "news_single_page"
          result.template_type = Template::TEMPLATE_TYPE[:single_type]    #单页
        when "留言板"  then
          result.template_category_id = content_id
          result.template_name = "message_borad"
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #单页
        when "购物车页面"  then
          result.template_category_id = order_id
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #单页
        when "用户弹窗单页"  then
          result.template_category_id = single_page_id
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #单页
        when "确认订单页"  then
          result.template_category_id = order_id
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #单页
        when "搜索页"  then
          result.template_category_id = single_page_id
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #单页
        when "支付页"  then
          result.template_category_id = order_id
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #单页
        when "我的订单列表"  then
          result.template_category_id = order_id
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #单页
        when "订单详细页"  then
          result.template_category_id = order_id
          result.template_type = Template::TEMPLATE_TYPE[:content_type]    #单页
        when "搜索分类页"  then
          result.template_category_id = partil_id
          result.template_type = Template::TEMPLATE_TYPE[:partil_type]    #版本
        end
        result.save
        p "----------#{result.template_name}------执行成功-------------------------"
      end

    end
  end

  def down
    remove_column :templates, :template_category_id 
  end


end
