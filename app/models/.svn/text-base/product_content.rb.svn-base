#encoding: UTF-8
class ProductContent < ActiveRecord::Base
  #软删除
  acts_as_paranoid
  #多态
  belongs_to :item,  :polymorphic => true


  mango_liquid  

end
