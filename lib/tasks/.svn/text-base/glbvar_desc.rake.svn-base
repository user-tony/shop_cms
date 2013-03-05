##encoding: UTF-8
namespace :mangocms do
  desc "默认网站初始化描述"
  task :glbvar_desc => :environment do
    begin
      global_variables = [ 
        ["Logo","logo", "网站徽标"],
        ["meta关键字", "meta_keyword", "用来告诉搜索引擎你网页的关键字是什么"],
        ["meta描述","meta_description", "用来告诉搜索引擎你的网站主要内容"],
        ["报错邮件", "bug_mail", "用来接收用户访问网站时出现的BUG"]]
      global_variables.each do |name, key_name, description|
        variable = GlobalVariable.where(:key_name => key_name).first
        variable.update_attributes(:description => description)
      end
    end
  end
end