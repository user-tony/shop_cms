#encoding: UTF-8
class ShopRekated < ActiveRecord::Migration

  def change
    #-----------------------------定义变量-------------------------------------
    templates = [["cart_pop_list", "购物车下拉弹窗", 13,7]]
    template_id = 0
    #-----------------------------模版导入-------------------------------------
    templates.reverse_each do |file, name,category_id,type|
      temp_path = "#{Rails.root}/lib/cms/init_templates/#{file}.html"
      if File.exists?(temp_path)
        File.open(temp_path, "r") do |f|
          puts ".....导入《#{name}》成功..." if cart_list = Template.create(
            :name => name,
            :template_name => file,
            :description => "系统默认模板",
            :content => f.read,
            :template_category_id => category_id,
            :template_type => type,
            :template_status => true
          )
          template_id = cart_list.id
        end
      else
        puts "《#{name}》不存在.."
      end
    end


    #-----------------------------栏目创建-------------------------------------
    puts "商城..." if shop =  Channel.create(
      :name => "商城",
      :path_customize => "shop",
      :show_nav => true,
      :channel_type => Channel::CHANNEL_TYPE[:original],
      :template_id_index => 12 ,
      :template_id_detail => 11 ,
      :info_model_id => 2,
      :parent_id => 1
    )
    puts "购物车默认单页模版..." if channel = Channel.create(
      :name => "购物车单页",
      :path_customize => "cart_list",
      :show_nav => false,
      :single_page => true,
      :channel_type => Channel::CHANNEL_TYPE[:original],
      :template_single => template_id,
      :info_model_id => 2,
      :parent_id => shop.id
    )
    CustomPage.create(:channel_id => channel.id)

    say "添加用户弹窗栏目"
    [["pop_sign", "用户弹窗登录", "pop_sign"]].each do |template, name, path_custom|
      temp_path = "#{Rails.root}/lib/cms/init_templates/#{template}.html"
      channel = Channel.new(:name => name, :path_customize => path_custom,
        :show_nav => false, :single_page => true,
        :final_page => true,
        :template_single => 14,
        :channel_type => Channel::CHANNEL_TYPE[:original],
        :info_model_id => 4,
        :parent_id => 2 )
      custom_page = channel.build_custom_page(:name => name)
      if File.exists?(temp_path)
        File.open(temp_path, "r") do |f|
          custom_page.build_custom_page_content(:content => f.read)
        end
      end
      if channel.save
        puts "#{name}栏目导入成功！"
      else
        puts "#{name}栏目导入失败！"
      end
    end
  end

  
  say "add system global_variable info"

  postion = GlobalVariable.last.position.to_i
  #评论功能默认审核通过
  GlobalVariable.create(:name => "评论功能默认审核通过", :key_name => "comment_default_status", :var_type => GlobalVariable::VARIABLE_TYPES["check_box"] ,:description => "评论功能默认审核通过" , :position => postion += 1, :global_variable_category_id => 1)
  #商城_热门搜素词
  GlobalVariable.create(:name => "商城_热门搜素词", :key_name => "shop_hot_search_keys", :var_type => GlobalVariable::VARIABLE_TYPES["array"] ,:description => "商城_热门搜素词 多个词中间用#分隔" , :position => postion += 1, :global_variable_category_id => 1, :content => "热门搜索词")


  #邮件订单提醒分类
  ordermail_inteface = GlobalVariableCategory.create({ :name => "订单邮件提醒", :parent_id => 0, :description => "提交订单时发送邮件", :level => GlobalVariableCategory::LEVEL_NORMAL, :depth => 0 }
)
  #+++++++++++++++++邮件提醒++++++++
  ordermail = GlobalVariableCategory.create(:name => "使用邮件进行订单提醒", :parent_id => ordermail_inteface.id , :description => "使用邮件进行订单提醒", :level => GlobalVariableCategory::LEVEL_NORMAL, :depth => 1 )
  GlobalVariable.create(:name => "是否启用", :key_name => "mail_order_enable", :var_type => GlobalVariable::VARIABLE_TYPES["check_box"] ,:description => "邮件订单提醒是否启用" , :position => postion += 1, :global_variable_category_id => ordermail.id )
  p "添加系统设置--订单邮件提醒--使用邮件进行订单提醒--是否启用"
  GlobalVariable.create(:name => "设置接收邮件地址", :key_name => "receive_mail_address", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "设置接收邮件地址" , :position => postion += 1, :global_variable_category_id => ordermail.id )
  p "添加系统设置--订单邮件提醒--使用邮件进行订单提醒--设置接收邮件地址"
  GlobalVariable.create(:name => "设置发送邮件地址", :key_name => "send_mail_address", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "设置发送邮件地址" , :position => postion += 1, :global_variable_category_id => ordermail.id )
  p "添加系统设置--订单邮件提醒--使用邮件进行订单提醒--设置发送邮件地址"
  GlobalVariable.create(:name => "设置发送邮件的邮箱密码", :key_name => "mail_order_cipher", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "设置发送邮件的邮箱密码" , :position => postion += 1, :global_variable_category_id => ordermail.id )


  #+++++++++++++++++系统设置++++++++
  system_settings = GlobalVariableCategory.create(:name => "系统设置", :parent_id => 0 , :description => "系统设置", :level => GlobalVariableCategory::LEVEL_HIGHEST, :depth => 0 )
  GlobalVariable.create(:name => "系统版本", :key_name => "version", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "系统版本" , :position => postion += 1, :global_variable_category_id => system_settings.id, :content => "v0.1" )
  p "添加系统设置--系统版本"

  
  Utils::CmsExtend.template_crete("shop_product_comments","商品评论页面","shop_product_comments",2,15 ,Template::TEMPLATE_TYPE[:partil_type])
  Utils::CmsExtend.template_crete("shop_product_buy_logs","商品购买记录","shop_product_buy_logs",2,15 ,Template::TEMPLATE_TYPE[:partil_type])


end
