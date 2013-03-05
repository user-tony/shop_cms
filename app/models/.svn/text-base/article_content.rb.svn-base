#encoding: UTF-8
class ArticleContent < ActiveRecord::Base

  #从属于一个文章
  belongs_to :article

   #软删除
  acts_as_paranoid
  #注册模板字段
  mango_liquid
end
