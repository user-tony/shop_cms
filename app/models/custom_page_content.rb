#encoding: UTF-8
class CustomPageContent < ActiveRecord::Base
  #注册模板字段
  mango_liquid
  #从属于自定义
  belongs_to :custom_page


  
end
