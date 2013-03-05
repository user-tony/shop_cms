#encoding: UTF-8
class AddGlobalVariableCategoryIdToGlobalVariables < ActiveRecord::Migration
  def up
    add_column  :global_variables,     :global_variable_category_id,     :integer                 #配置分类id
    GlobalVariable.reset_column_information
    #网站设置初始化
    # 类型说明：  integer: 0, string: 1, boolean: 2, text: 3, image: 4
    #添加系统设置分类
    setting = GlobalVariableCategory.create({ :name => "全局设置", :parent_id => 0, :description => "网站默认设置", :level => GlobalVariableCategory::LEVEL_NORMAL, :depth => 0 })
    p "添加系统设置分类成功"
    say "setting"
    postion = 0
    GlobalVariable.create(:name => "网站名称", :key_name => "web_name", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--网站名称"
    GlobalVariable.create(:name => "Logo", :key_name => "logo", :var_type => GlobalVariable::VARIABLE_TYPES["picture"] ,:description => "网站徽标" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--Logo"
    GlobalVariable.create(:name => "Favicon", :key_name => "favicon", :var_type => GlobalVariable::VARIABLE_TYPES["picture"] ,:description => "" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--Favicon"
    GlobalVariable.create(:name => "meta关键字", :key_name => "meta_keyword", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "用来告诉搜索引擎你网页的关键字是什么" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--meta关键字"
    GlobalVariable.create(:name => "meta描述", :key_name => "meta_description", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "用来告诉搜索引擎你的网站主要内容" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--meta描述"
    GlobalVariable.create(:name => "版权信息", :key_name => "copyright_info", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--版权信息"
    GlobalVariable.create(:name => "平台代码", :key_name => "platform_code", :var_type => GlobalVariable::VARIABLE_TYPES["text"] ,:description => "" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--平台代码"
    GlobalVariable.create(:name => "统计代码", :key_name => "statistical_code", :var_type => GlobalVariable::VARIABLE_TYPES["text"] ,:description => "" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--统计代码"
    GlobalVariable.create(:name => "报错邮件", :key_name => "bug_mail", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "用来接收用户访问网站时出现的BUG" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--报错邮件"
    GlobalVariable.create(:name => "域名", :key_name => "web_site_url", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "网站域名,格式：http://www.localhost.com" , :position => postion += 1, :global_variable_category_id => setting.id )
    p "添加系统设置--域名"

    alipay_inteface = GlobalVariableCategory.create({ :name => "支付接口", :parent_id => 0, :description => "商城支付宝信息", :level => GlobalVariableCategory::LEVEL_NORMAL, :depth => 0 })
    #+++++++++++++++++支付宝++++++++\
    say "alipay_inteface"
    alipay = GlobalVariableCategory.create(:name => "支付宝", :parent_id => alipay_inteface.id , :description => "商城支付宝信息", :level => GlobalVariableCategory::LEVEL_NORMAL, :depth => 1 )
    GlobalVariable.create(:name => "是否启用", :key_name => "payment_alipay_enable", :content => true, :var_type => GlobalVariable::VARIABLE_TYPES["check_box"] ,:description => "支付宝是否启用" , :position => postion += 1, :global_variable_category_id => alipay.id )
    p "添加系统设置--支付接口--支付宝--是否启用"
    GlobalVariable.create(:name => "安全检验码", :key_name => "payment_alipay_security_code", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "支付宝安全检验码" , :position => postion += 1, :global_variable_category_id => alipay.id )
    p "添加系统设置--支付接口--支付宝--安全检验码"
    GlobalVariable.create(:name => "合作伙伴ID", :key_name => "payment_alipay_partner", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "合作伙伴ID" , :position => postion += 1, :global_variable_category_id => alipay.id )
    p "添加系统设置--支付接口--支付宝--合作伙伴ID"
    GlobalVariable.create(:name => "支付宝帐户", :key_name => "payment_alipay_seller_email", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "支付宝账号" , :position => postion += 1, :global_variable_category_id => alipay.id )
    p "添加系统设置--支付接口--支付宝--支付宝帐户"

    #+++++++++++++++++网银在线++++++++
    say "online_banking"
    online_banking = GlobalVariableCategory.create(:name => "网银在线", :parent_id => alipay_inteface.id , :description => "网银在线信息", :level => GlobalVariableCategory::LEVEL_NORMAL, :depth => 1 )
    GlobalVariable.create(:name => "是否启用", :key_name => "payment_chinabank_enable", :var_type => GlobalVariable::VARIABLE_TYPES["check_box"] ,:description => "网银在线是否启用" , :position => postion += 1, :global_variable_category_id => online_banking.id )
    p "添加系统设置--支付接口--网银在线--是否启用"
    GlobalVariable.create(:name => "商户ID", :key_name => "payment_chinabank_v_mid", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "商户ID" , :position => postion += 1, :global_variable_category_id => online_banking.id )
    p "添加系统设置--支付接口--网银在线--商户ID"
    GlobalVariable.create(:name => "商户密钥", :key_name => "payment_chinabank_key", :var_type => GlobalVariable::VARIABLE_TYPES["string"] ,:description => "商户密钥" , :position => postion += 1, :global_variable_category_id => online_banking.id )
    p "添加系统设置--支付接口--网银在线--商户密钥"
  end

  def down
    remove_columns  :global_variables,     :global_variable_category_id
  end
end
