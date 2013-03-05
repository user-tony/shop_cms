#encoding: UTF-8
class CreateInfoModels < ActiveRecord::Migration
  def change
    create_table :info_models, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name,               :string,  :limit => 100      #模块名称
      t.column :description,        :string                      #描述
      t.column :model_name,         :string                      #rails的模型名
      t.column :info_model_status,  :boolean, :default => false  #状态（默认不可用）

      t.timestamps
    end
    #############################################################
    #模型初始数据
    puts "模型数据导入完成..." if InfoModel.create(:name => "新闻系统", :description =>"系统默认模型", :model_name => "Article", :info_model_status => true)
    puts "商城模型导入完成..." if InfoModel.create(:name => "商城系统", :description => "商城模型", :model_name => "ShopProduct", :info_model_status => true)
    puts "订单模型导入完成..." if  InfoModel.create(:name => "订单系统", :description => "订单模型", :model_name => "Order", :info_model_status => true)
    puts "用户模型导入完成..." if  InfoModel.create(:name => "用户系统", :description => "用户模型", :model_name => "Member", :info_model_status => true)
    puts "产品模型导入成功..." if  InfoModel.create(:name => "产品系统", :description => "产品模型", :model_name => "Product", :info_model_status => true)
    puts "留言模型导入成功..." if InfoModel.create(:name => "留言系统", :description => "留言模型", :model_name => "Answer", :info_model_status => true)

  end
end
