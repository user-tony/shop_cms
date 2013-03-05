#encoding: UTF-8
class CreateTemplateCategories < ActiveRecord::Migration
  def change
    create_table :template_categories, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name,             :string                              #模版分类名称
      t.column :group_id,         :integer                             #模版分类分组ID
      t.column :description,      :string                              #模版分类描述
      t.column  :sort_id,         :integer, :default => 0              #排序ID
      t.column  :type_id,         :integer, :default => 0              #模版类型
      t.column  :info_model_id,   :integer                             #模型ID
      t.timestamps
    end
    if TemplateCategory.count < 1
      #初始化表后,添加数据
      TemplateCategory.create(:name => "首页", :group_id => 1,  :description => "网站首页模版（网站首页）")
      TemplateCategory.create(:name => "新闻栏目页",:info_model_id => 1, :group_id => 2, :type_id => TemplateCategory::TEMPLATE_TYPE[:channel], :description => "新闻列表模版")
      TemplateCategory.create(:name => "商城首页",:info_model_id => 2, :group_id => 3,   :type_id => TemplateCategory::TEMPLATE_TYPE[:channel], :description => "商城栏目模版")
      TemplateCategory.create(:name => "新闻列表页",:info_model_id => 1, :group_id => 2, :type_id => TemplateCategory::TEMPLATE_TYPE[:list], :description => "新闻列表模版")
      TemplateCategory.create(:name => "商城列表页",:info_model_id => 2, :group_id => 3, :type_id => TemplateCategory::TEMPLATE_TYPE[:list], :description => "商城列表模版")
      TemplateCategory.create(:name => "产品列表页",:info_model_id => 5, :group_id => 4, :type_id => TemplateCategory::TEMPLATE_TYPE[:list], :description => "产品列表模版")
      TemplateCategory.create(:name => "新闻显示页",:info_model_id => 1, :group_id => 2, :type_id => TemplateCategory::TEMPLATE_TYPE[:content], :description => "新闻显示模版")
      TemplateCategory.create(:name => "商城显示页",:info_model_id => 2, :group_id => 3, :type_id => TemplateCategory::TEMPLATE_TYPE[:content], :description => "商品显示模版")
      TemplateCategory.create(:name => "留言显示页",:info_model_id => 6, :group_id => 10, :type_id => TemplateCategory::TEMPLATE_TYPE[:content], :description => "留言显示模版")
      TemplateCategory.create(:name => "产品显示页",:info_model_id => 5, :group_id => 4, :type_id => TemplateCategory::TEMPLATE_TYPE[:content], :description => "产品显示模版")
      TemplateCategory.create(:name => "用户",:info_model_id => 4, :group_id => 11, :description => "用户登陆、注册等相关模版")
      TemplateCategory.create(:name => "订单",:info_model_id => 3, :group_id => 5, :description => "订单显示，弹窗等有关模版")
      TemplateCategory.create(:name => "自定义页", :group_id => 7, :type_id => TemplateCategory::TEMPLATE_TYPE[:single], :description => "所有单页模版（自定义模版）")
      TemplateCategory.create(:name => "其它", :group_id => 9, :description => "其它模版")
      TemplateCategory.create(:name => "片段", :group_id => 8, :description => "公共模版（很多地方可以共用的模版,例如：网站头部、导航、底部")
    end

  end
end
