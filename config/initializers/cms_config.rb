require 'cms/init.rb'
require "rmmseg"
#初始化网站配置
begin
	GlobalVariable.global_var
rescue
  nil
end
#模板资源目录
$mango_skin_path = "skin"


#加载自定义词库
RMMSeg::Dictionary.load_words("#{Rails.root}/config/words/words.dic")

#报错邮件
if $cms_global_variable&&$cms_global_variable['bug_mail'].present?
  Mangocms::Application.config.middleware.use ::ExceptionNotifier,
    :email_prefix => "[Mangocms]",
    :sender_address => %{"notifier" <cms_error@163.com>},
    :exception_recipients => [$cms_global_variable['bug_mail']],
    :sections => %w(request session environment backtrace)
end
#-----------模板相关配置-----------------
require 'liquid/init.rb'
#栏目标签
Cms::register_tag(Channel)
#文章标签
Cms::register_tag(Article)
#友情链接标签
Cms::register_tag(FriendlyWebsite)
#产品标签
Cms::register_tag(Product)
#产品分类标签
Cms::register_tag(ProductCategory)
#招聘信息
Cms::register_tag(Zhaopin)
#文章标签
Cms::register_tag(ProductAttachment)
#商品标签
Cms::register_tag(ShopProduct)
#商品套餐标签
Cms::register_tag(ShopPackage)
#用户地址
Cms::register_tag(OrderAddress)
#商品分类标签
Cms::register_tag(ShopCategory)
#专家回答标签
Cms::register_tag(ReplyAnswer)
#问答标签
Cms::register_tag(Answer)
#省份
Cms::register_tag(AreaProvince)
#城市
Cms::register_tag(AreaCity)
#地区
Cms::register_tag(AreaCountry)
#产品内容
Cms::register_tag(ProductContent)

