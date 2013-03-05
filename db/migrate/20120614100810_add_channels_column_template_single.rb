#encoding: UTF-8
class AddChannelsColumnTemplateSingle < ActiveRecord::Migration
  def change
    add_column :channels, :template_single,  :integer                  #添加栏目单页字段
    Channel.reset_column_information

    [["sign_up", "用户注册", "sign_up"], ["sign_in", "用户登录", "sign_in"]].each do |template, name, path_custom|
      temp_path = "#{Rails.root}/lib/cms/init_templates/#{template}.html"
      channel = Channel.new(:name => name, :path_customize => path_custom,
        :show_nav => false, :single_page => true,
        :final_page => true,
        :template_single => 15,
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
end
